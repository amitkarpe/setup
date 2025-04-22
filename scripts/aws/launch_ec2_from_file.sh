#!/usr/bin/env bash
# Launches EC2 instance based on configuration from an external file.

set -euo pipefail
# set -x # Uncomment for debugging

# --- Check for Environment File Argument --- 
if [[ -z "$1" ]]; then
    echo "Usage: $0 <environment_file>" >&2
    echo "Error: No environment file provided." >&2
    exit 1
fi

ENV_FILE="$1"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: Environment file not found: $ENV_FILE" >&2
    exit 1
fi

# --- Source Configuration from File --- 
echo "Sourcing configuration from $ENV_FILE..."
source "$ENV_FILE"

# --- Validate Required Variables (Add more as needed) --- 
required_vars=("REGION" "INSTANCE_TYPE" "VPC_ID" "SUBNET_ID" "IAM_ROLE_NAME" "SECURITY_GROUP_IDS" "KEY_NAME" "VOLUME_SIZE_GB")
missing_vars=0
for var in "${required_vars[@]}"; do
    # Use indirect expansion to check if var is set
    if [[ -z "${!var:-}" ]]; then
        echo "Error: Required variable '$var' not set in $ENV_FILE." >&2
        missing_vars=1
    fi
done
if [[ $missing_vars -eq 1 ]]; then
    exit 1
fi

# --- Set Defaults if Not Provided --- 
INSTANCE_NAME=${INSTANCE_NAME:-"ubuntu-$(date +%Y%m%d-%H%M)"} # Default if INSTANCE_NAME is empty or unset
TAG_CREATED_BY=${TAG_CREATED_BY:-"scripted-launch"}         # Default if TAG_CREATED_BY is empty or unset
USER_DATA_SCRIPT=${USER_DATA_SCRIPT:-"scripts/aws/user_data_nextflow_setup.sh"} # Default user data

# --- Find Latest Ubuntu 22.04 LTS AMI (if not provided or FIND_LATEST) --- 
if [[ -z "${LATEST_AMI_ID:-}" || "$LATEST_AMI_ID" == "FIND_LATEST" ]]; then
    if [[ -z "${LATEST_AMI_ID:-}" ]]; then
        echo "LATEST_AMI_ID not set in $ENV_FILE. Finding latest Ubuntu 22.04 LTS AMI in $REGION..."
    else # FIND_LATEST was specified
        echo "FIND_LATEST specified for LATEST_AMI_ID. Finding latest Ubuntu 22.04 LTS AMI in $REGION..."
    fi
    
    LATEST_AMI_ID_FOUND=$(aws ec2 describe-images --region "$REGION" \
      --owners 099720109477 \
      --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" "Name=state,Values=available" \
      --query 'sort_by(Images, &CreationDate)[-1].ImageId' \
      --output text)

    if [[ -z "$LATEST_AMI_ID_FOUND" ]]; then
      echo "Error: Could not find the latest Ubuntu 22.04 LTS AMI ID." >&2
      exit 1
    fi
    LATEST_AMI_ID="$LATEST_AMI_ID_FOUND"
    echo "Found AMI ID: $LATEST_AMI_ID"
elif [[ ! -z "${LATEST_AMI_ID:-}" ]]; then 
    echo "Using specific AMI ID from $ENV_FILE: $LATEST_AMI_ID"
else
    echo "Error: LATEST_AMI_ID logic error." >&2 # Should not happen with checks above
    exit 1
fi

# --- Check User Data Script Exists --- 
if [[ ! -f "$USER_DATA_SCRIPT" ]]; then
    echo "Error: User data script not found: $USER_DATA_SCRIPT" >&2
    exit 1
fi

# --- Construct and Run EC2 Instance using simpler CLI args --- 
echo "Launching EC2 instance $INSTANCE_NAME (AMI: $LATEST_AMI_ID) in $REGION..."

aws ec2 run-instances \
  --region "$REGION" \
  --image-id "$LATEST_AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --iam-instance-profile Name="$IAM_ROLE_NAME" \
  --subnet-id "$SUBNET_ID" \
  --security-group-ids $SECURITY_GROUP_IDS \
  --block-device-mappings "DeviceName=/dev/sda1,Ebs={VolumeSize=$VOLUME_SIZE_GB,VolumeType=gp3,DeleteOnTermination=true}" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME},{Key=CreatedBy,Value=$TAG_CREATED_BY}]" "ResourceType=volume,Tags=[{Key=Name,Value=${INSTANCE_NAME}-rootvol},{Key=CreatedBy,Value=$TAG_CREATED_BY}]" \
  --user-data "file://$USER_DATA_SCRIPT" \
  --count 1

INSTANCE_INFO=$(aws ec2 describe-instances \
  --region $REGION \
  --filters "Name=tag:Name,Values=$INSTANCE_NAME" "Name=instance-state-name,Values=pending,running" \
  --query 'Reservations[].Instances[?LaunchTime>=`date +%s -d "5 minutes ago"`].[InstanceId,State.Name,LaunchTime]' \
  --output text)

echo ""
echo "Instance launch requested. Details:"
echo "$INSTANCE_INFO"
echo "Check the AWS console or use 'aws ec2 describe-instances' for full status."

# Optional: Add a call to the status script here if desired
# echo "Fetching status of latest instance..."
# bash scripts/aws/status_latest_ec2.sh # Assuming status script exists
