# Launching EC2 Instances from Configuration File

This document describes how to use the `scripts/aws/launch_ec2_from_file.sh` script to launch EC2 instances based on parameters defined in an external configuration file.

## Prerequisites

- AWS CLI installed and configured with appropriate credentials.
- Permissions to perform `ec2:DescribeImages` and `ec2:RunInstances`.
- An existing VPC, Subnet, Security Groups, IAM Role, and Key Pair as defined within the configuration file.
- A User Data script (defaults to `scripts/aws/user_data_nextflow_setup.sh` if not specified in the config file).

## Configuration File

Create an environment file (e.g., `my-ec2.env`) with shell variable assignments for the instance parameters.

**Example (`my-ec2.env`):**

```bash
# Required
REGION="ap-southeast-1"
INSTANCE_TYPE="t3.xlarge"
VPC_ID="vpc-xxxxxxxx"
SUBNET_ID="subnet-xxxxxxxx"
IAM_ROLE_NAME="YourIAMRoleName"
SECURITY_GROUP_IDS="sg-xxxxxxxx sg-yyyyyyyy" # Space-separated
KEY_NAME="your-key-pair"
VOLUME_SIZE_GB=200

# Optional - AMI ID
# Leave empty, omit, or set to "FIND_LATEST" to find the latest Ubuntu 22.04 LTS AMI
# Set to a specific AMI ID (e.g., "ami-xxxxxxxxxxxxxxxxx") to use that one.
LATEST_AMI_ID=""

# Optional - Naming & Tagging
INSTANCE_NAME="my-custom-instance-name" # Defaults to ubuntu-YYYYMMDD-HHMM
TAG_CREATED_BY="your-name"           # Defaults to scripted-launch

# Optional - User Data
# USER_DATA_SCRIPT="path/to/your/user_data.sh" # Defaults to scripts/aws/user_data_nextflow_setup.sh
```

See the script (`launch_ec2_from_file.sh`) for the exact list of required and optional variables.

## Usage

Run the launch script from the repository root, providing the path to your environment file as the first argument:

```bash
bash scripts/aws/launch_ec2_from_file.sh path/to/your/my-ec2.env
```

The script will:
1.  Source the variables from your environment file.
2.  Validate required variables.
3.  Find the latest Ubuntu 22.04 LTS AMI if `LATEST_AMI_ID` is not specified or set to `FIND_LATEST`.
4.  Check that the specified User Data script exists.
5.  Execute the `aws ec2 run-instances` command with the configured parameters.
6.  Output basic details of the requested instance.

Instance setup (via the User Data script) happens automatically in the background. Monitor progress in `/var/log/user-data.log` on the instance. 