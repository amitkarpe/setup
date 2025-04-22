#!/usr/bin/env bash

set -euo pipefail
# set -x # Keep commented out unless debugging

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
    if [[ -z "${!var:-}" ]]; then
        echo "Error: Required variable '$var' not set in $ENV_FILE." >&2
        missing_vars=1
    fi
done
if [[ $missing_vars -eq 1 ]]; then
    exit 1
fi

# --- Set Defaults if Not Provided --- 
# Define defaults directly here or source a default.env first
INSTANCE_NAME=${INSTANCE_NAME:-"ubuntu-$(date +%Y%m%d-%H%M)"} # Default if INSTANCE_NAME is empty or unset
TAG_CREATED_BY=${TAG_CREATED_BY:-"scripted-launch"}         # Default if TAG_CREATED_BY is empty or unset

# --- REMOVED Hardcoded Configuration Variables --- 

# --- Find Latest Ubuntu 22.04 LTS AMI (if not provided) --- 
if [[ -z "${LATEST_AMI_ID:-}" ]]; then
    echo "LATEST_AMI_ID not set in $ENV_FILE. Finding latest Ubuntu 22.04 LTS AMI in $REGION..."
    # Using AWS CLI to get the latest Ubuntu 22.04 LTS (Jammy) AMI ID for amd64
    # Owner alias 'amazon' can sometimes be used, but canonical is safer (099720109477)
    LATEST_AMI_ID_FOUND=$(aws ec2 describe-images --region "$REGION" \
      --owners 099720109477 \
      --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" "Name=state,Values=available" \
      --query 'sort_by(Images, &CreationDate)[-1].ImageId' \
      --output text)

    if [[ -z "$LATEST_AMI_ID_FOUND" ]]; then
      echo "Error: Could not find the latest Ubuntu 22.04 LTS AMI ID." >&2
      exit 1
    fi
    # Assign the found ID back to the variable used later
    LATEST_AMI_ID="$LATEST_AMI_ID_FOUND"
    echo "Found AMI ID: $LATEST_AMI_ID"
elif [[ "$LATEST_AMI_ID" == "FIND_LATEST" ]]; then # Optional: Allow explicitly requesting lookup
    echo "FIND_LATEST specified for LATEST_AMI_ID. Finding latest Ubuntu 22.04 LTS AMI in $REGION..."
    # ... (duplicate the lookup logic above or refactor into a function)
    LATEST_AMI_ID_FOUND=$(aws ec2 describe-images --region "$REGION" \
      --owners 099720109477 \
      --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" "Name=state,Values=available" \
      --query 'sort_by(Images, &CreationDate)[-1].ImageId' \
      --output text)
    # ... (error check)
    LATEST_AMI_ID="$LATEST_AMI_ID_FOUND"
    echo "Found AMI ID: $LATEST_AMI_ID"
else
    echo "Using AMI ID from $ENV_FILE: $LATEST_AMI_ID"
fi

# --- Construct and Run EC2 Instance using simpler CLI args --- 
echo "Launching EC2 instance..."

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
  --user-data file://scripts/aws/user_data_nextflow_setup.sh \
  --count 1

echo ""
echo "Instance launch command executed. Check the AWS console or use 'aws ec2 describe-instances' for status." 

aws ec2 describe-instances \
  --region ap-southeast-1 \
  --query 'Reservations[].Instances[] | sort_by(@, &LaunchTime) | reverse(@)[0].{InstanceId: InstanceId, Name: Tags[?Key==`Name`].Value | [0], State: State.Name, LaunchTime: LaunchTime}' \
  --output table
