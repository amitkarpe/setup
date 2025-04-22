#!/usr/bin/env bash

set -euo pipefail

# --- Configuration --- 
# Retrieved from issues.md
REGION="ap-southeast-1"
INSTANCE_TYPE="t3.xlarge"
VPC_ID="vpc-035eb12babd9ca798"
SUBNET_ID="subnet-0d13ba2dcbb0f6d46"
IAM_ROLE_NAME="TerraformProductionAccessRole"
SECURITY_GROUP_IDS="sg-0276a736dda5e4a3f sg-01d367382d6cfe56c sg-02828916c4212e616"
KEY_NAME="amit"
VOLUME_SIZE_GB=200
INSTANCE_NAME="ubuntu-$(date +%Y%m%d-%H%M)" # Example naming convention
TAG_CREATED_BY="scripted-launch"

# --- Find Latest Ubuntu 22.04 LTS AMI --- 
echo "Finding latest Ubuntu 22.04 LTS AMI in $REGION..."

# Using AWS CLI to get the latest Ubuntu 22.04 LTS (Jammy) AMI ID for amd64
# Owner alias 'amazon' can sometimes be used, but canonical is safer (099720109477)
LATEST_AMI_ID=$(aws ec2 describe-images --region "$REGION" \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" "Name=state,Values=available" \
  --query 'sort_by(Images, &CreationDate)[-1].ImageId' \
  --output text)

if [[ -z "$LATEST_AMI_ID" ]]; then
  echo "Error: Could not find the latest Ubuntu 22.04 LTS AMI ID." >&2
  exit 1
fi

echo "Found AMI ID: $LATEST_AMI_ID"

# --- Prepare Block Device Mapping JSON --- 
# Note: For GP3, you might specify IOPS/Throughput. For GP2, just size.
# Ensure the device name (/dev/sda1 or /dev/xvda) matches the AMI's root device name.
# You might need to check the AMI details manually or with describe-images if unsure.
# Assuming /dev/sda1 for standard Ubuntu AMIs from Canonical.
BLOCK_DEVICE_MAPPINGS='[{"DeviceName": "/dev/sda1", "Ebs": {"VolumeSize": '$VOLUME_SIZE_GB', "VolumeType": "gp3", "DeleteOnTermination": true}}]'

# --- Prepare Tags Specification --- 
TAG_SPECIFICATIONS='[{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"'$INSTANCE_NAME'"},{"Key":"CreatedBy","Value":"'$TAG_CREATED_BY'"}]},{"ResourceType":"volume","Tags":[{"Key":"Name","Value":"'$INSTANCE_NAME'-rootvol'"},{"Key":"CreatedBy","Value":"'$TAG_CREATED_BY'"}]}]'

# --- Prepare Network Interface JSON --- 
# Format security groups correctly into a JSON array of strings
FORMATTED_SG_IDS=""
for sg in $SECURITY_GROUP_IDS; do
  FORMATTED_SG_IDS+="\"$sg\","
done
# Remove trailing comma
FORMATTED_SG_IDS=${FORMATTED_SG_IDS%,}

NETWORK_INTERFACES='[{"DeviceIndex": 0, "SubnetId": "'$SUBNET_ID'", "Groups": ['$FORMATTED_SG_IDS'], "AssociatePublicIpAddress": true}]'

# --- Construct and Run EC2 Instance --- 
echo "Launching EC2 instance..."

aws ec2 run-instances \
  --region "$REGION" \
  --image-id "$LATEST_AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --iam-instance-profile Name="$IAM_ROLE_NAME" \
  --network-interfaces "$NETWORK_INTERFACES" \
  --block-device-mappings "$BLOCK_DEVICE_MAPPINGS" \
  --tag-specifications "$TAG_SPECIFICATIONS" \
  --count 1


INSTANCE_INFO=$(aws ec2 describe-instances \
  --region $REGION \
  --filters "Name=tag:Name,Values=$INSTANCE_NAME" "Name=instance-state-name,Values=pending,running" \
  --query 'Reservations[].Instances[].[InstanceId,State.Name,LaunchTime]' \
  --output text)

echo ""
echo "Instance launch requested. Details:"
echo "$INSTANCE_INFO"
echo "Check the AWS console or use 'aws ec2 describe-instances' for full status."

# Export the ID of the latest instance launched (based on Name tag filter)
echo "Exporting LAST_INSTANCE_ID..."
export LAST_INSTANCE_ID=$(aws ec2 describe-instances \
  --region $REGION \
  --filters "Name=tag:Name,Values=$INSTANCE_NAME" "Name=instance-state-name,Values=pending,running" \
  --query 'Reservations[].Instances[0].InstanceId' \
  --output text)

if [[ -n "$LAST_INSTANCE_ID" ]]; then
  echo "LAST_INSTANCE_ID=$LAST_INSTANCE_ID"
else
  echo "Warning: Could not determine LAST_INSTANCE_ID from describe-instances output."
fi