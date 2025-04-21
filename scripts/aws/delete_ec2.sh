#!/usr/bin/env bash

set -euo pipefail

# --- Check Input --- 
if [[ -z "$1" ]]; then
    echo "Usage: $0 <instance-id>" >&2
    echo "Error: No EC2 Instance ID provided." >&2
    exit 1
fi

INSTANCE_ID="$1"
REGION="ap-southeast-1" # Assuming the same region as launch, make this configurable if needed

# --- Confirm Deletion --- 
echo "You are about to terminate EC2 instance: $INSTANCE_ID in region $REGION."
read -p "Are you sure? (y/N): " confirmation

if [[ "$confirmation" != "y" ]] && [[ "$confirmation" != "Y" ]]; then
    echo "Termination cancelled."
    exit 0
fi

# --- Terminate Instance --- 
echo "Terminating instance $INSTANCE_ID..."

aws ec2 terminate-instances \
  --region "$REGION" \
  --instance-ids "$INSTANCE_ID"

# You can add describe-instances calls here to wait for termination if needed
# aws ec2 wait instance-terminated --region "$REGION" --instance-ids "$INSTANCE_ID"

echo ""
echo "Terminate instance command executed for $INSTANCE_ID. Check the AWS console for status." 