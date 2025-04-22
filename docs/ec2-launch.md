# Launching EC2 Instances with Script

This document describes how to use the provided script to launch a pre-configured EC2 instance.

## Prerequisites

- AWS CLI installed and configured with appropriate credentials.
- Permissions to perform `ec2:DescribeImages` and `ec2:RunInstances`.
- The `make` command installed. If not present, run: `bash scripts/common/install_make.sh`
- An existing VPC, Subnet, Security Groups, IAM Role, and Key Pair as defined within the script.

## Configuration

Instance configuration is now provided via an external environment file (e.g., `my-ec2.env`). This file should contain shell variable assignments for the required parameters.

**Example Environment File (`my-ec2.env`):**

```bash
REGION="ap-southeast-1"
INSTANCE_TYPE="t3.xlarge"
VPC_ID="vpc-xxxxxxxx"
SUBNET_ID="subnet-xxxxxxxx"
IAM_ROLE_NAME="YourIAMRoleName"
SECURITY_GROUP_IDS="sg-xxxxxxxx sg-yyyyyyyy"
KEY_NAME="your-key-pair"
VOLUME_SIZE_GB=200

# Optional:
LATEST_AMI_ID="ami-xxxxxxxxxxxxxxxxx" # Leave empty or omit to find latest Ubuntu 22.04
INSTANCE_NAME="my-custom-instance-name" # Optional, defaults to ubuntu-YYYYMMDD-HHMM
TAG_CREATED_BY="your-name"           # Optional, defaults to scripted-launch
```

**Required Variables:**
- `REGION`
- `INSTANCE_TYPE`
- `VPC_ID`
- `SUBNET_ID`
- `IAM_ROLE_NAME`
- `SECURITY_GROUP_IDS` (space-separated)
- `KEY_NAME`
- `VOLUME_SIZE_GB`

**Optional Variables:**
- `LATEST_AMI_ID`: If set, uses this AMI ID. If empty or omitted, the script finds the latest Ubuntu 22.04 LTS AMI for the specified region. You can also set it to `FIND_LATEST` to explicitly trigger the lookup.
- `INSTANCE_NAME`: Base name for the instance tag.
- `TAG_CREATED_BY`: Value for the 'CreatedBy' tag.

## Usage

1.  Create an environment file (e.g., `my-ec2.env`) with your desired configuration.
2.  Run the launch script from the repository root, providing the path to your environment file as the first argument:

    ```bash
    bash scripts/aws/launch_ec2.sh path/to/your/my-ec2.env
    ```

    *(Using the Makefile is no longer the primary method for this script)*

This will execute the `launch_ec2.sh` script, which performs the following:

1.  Finds Latest AMI.
2.  Constructs Command.
3.  Launches Instance, passing a User Data script (`scripts/aws/user_data_nextflow_setup.sh`) to automatically install Nextflow, nf-core, Apptainer, Docker, Podman, and other prerequisites on boot.

The script outputs the found AMI ID and confirms the launch command execution. Instance setup happens automatically in the background. You can monitor the setup progress by checking the User Data log file (`/var/log/user-data.log`) on the instance once it boots.

## Deleting Instances

A script is provided to terminate instances launched by this process (or any instance).

1.  You need the **Instance ID** of the EC2 instance you want to terminate.
2.  Navigate to the `scripts/aws` directory.
3.  Run the `delete` target using the Makefile, providing the Instance ID:

    ```bash
    cd scripts/aws
    make delete INSTANCE_ID=i-xxxxxxxxxxxxxxxxx 
    ```
    (Replace `i-xxxxxxxxxxxxxxxxx` with the actual Instance ID)

This will execute `delete_ec2.sh`:
- It will ask for confirmation before proceeding.
- It executes the `aws ec2 terminate-instances` command for the specified ID.

**Warning:** Termination is permanent and cannot be undone. 