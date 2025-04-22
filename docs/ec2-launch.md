# Launching EC2 Instances with Script

This document describes how to use the provided script to launch a pre-configured EC2 instance.

## Prerequisites

- AWS CLI installed and configured with appropriate credentials.
- Permissions to perform `ec2:DescribeImages` and `ec2:RunInstances`.
- An existing VPC, Subnet, Security Groups, IAM Role, and Key Pair as defined within the script.

## Configuration

The script `scripts/aws/launch_ec2.sh` contains configuration variables at the top:

- `REGION`: AWS Region (e.g., `ap-southeast-1`)
- `INSTANCE_TYPE`: EC2 Instance Type (e.g., `t3.xlarge`)
- `VPC_ID`: Target VPC ID
- `SUBNET_ID`: Target Subnet ID
- `IAM_ROLE_NAME`: Name of the IAM Instance Profile Role
- `SECURITY_GROUP_IDS`: Space-separated list of Security Group IDs
- `KEY_NAME`: Name of the EC2 Key Pair
- `VOLUME_SIZE_GB`: Size of the root EBS volume in GB (e.g., `200`)
- `INSTANCE_NAME`: Base name for the instance tag (timestamp will be appended)
- `TAG_CREATED_BY`: Value for the 'CreatedBy' tag

Modify these variables directly in the script if needed for different launches.

## Usage

1.  Navigate to the `scripts/aws` directory.
2.  Run the launch target using the Makefile:

    ```bash
    cd scripts/aws
    make launch
    ```

This will execute the `launch_ec2.sh` script, which performs the following:

1.  **Finds Latest AMI:** Automatically queries AWS for the latest Ubuntu 22.04 LTS (Jammy) server AMI ID for the specified region.
2.  **Constructs Command:** Builds the `aws ec2 run-instances` command using the configuration variables and the found AMI ID.
3.  **Launches Instance:** Executes the command to request the instance launch.

The script outputs the found AMI ID and confirms the launch command execution. Check the AWS console for the instance status and details (like Public IP). 