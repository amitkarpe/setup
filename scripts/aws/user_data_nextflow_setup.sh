#!/bin/bash
# EC2 User Data script to set up Nextflow, nf-core, Apptainer, and Container tools on Ubuntu

set -euxo pipefail
export DEBIAN_FRONTEND=noninteractive

# --- Log Setup --- 
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Starting User Data script execution..."

# Wait for apt/dpkg locks if system is busy
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 || fuser /var/lib/apt/lists/lock >/dev/null 2>&1 ; do
   echo "Waiting for apt/dpkg lock release..."
   sleep 5
done

# --- Update and Install Base Prerequisites --- 
echo "Updating package lists and installing base prerequisites..."
apt-get update -y
apt-get install -y --no-install-recommends \
    wget \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    make \
    git \
    unzip \
    tree \
    tmux \
    nano \
    vim \
    net-tools \
    zsh \
    htop \
    jq \
    software-properties-common \
    openjdk-21-jdk \
    python3 \
    python3-pip \
    python3-venv \
    golang \
    squashfs-tools \
    fuse2fs \
    awscli \
    s3fs

# --- Install Docker --- 
echo "Installing Docker via get.docker.com..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sh /tmp/get-docker.sh
    rm /tmp/get-docker.sh
    # Add default ubuntu user to docker group
    if id ubuntu &> /dev/null; then
      usermod -aG docker ubuntu
      echo "Added 'ubuntu' user to docker group."
    else
      echo "Default user 'ubuntu' not found, skipping add to docker group."
    fi
else
    echo "Docker already found."
fi
# Install Docker plugins
apt-get install -y --no-install-recommends docker-buildx-plugin docker-compose-plugin

# --- Install Podman Ecosystem --- 
echo "Installing Podman, Buildah, Skopeo..."
apt-get install -y --no-install-recommends podman buildah skopeo

# --- Install Apptainer --- 
echo "Installing Apptainer..."
if ! command -v apptainer &> /dev/null; then
    APPTAINER_DEB_URL="https://github.com/apptainer/apptainer/releases/download/v1.4.0/apptainer_1.4.0_amd64.deb"
    APPTAINER_DEB_TMP="/tmp/apptainer_1.4.0_amd64.deb"
    echo "Downloading Apptainer from $APPTAINER_DEB_URL..."
    wget "$APPTAINER_DEB_URL" -O "$APPTAINER_DEB_TMP"
    echo "Installing Apptainer from $APPTAINER_DEB_TMP..."
    apt-get install -y "$APPTAINER_DEB_TMP"
    echo "Cleaning up downloaded file..."
    rm -f "$APPTAINER_DEB_TMP"
else
    echo "Apptainer already found."
fi

# --- Install Nextflow --- 
echo "Installing Nextflow..."
if ! command -v nextflow &> /dev/null; then
    echo "Nextflow not found or not executable. Installing..."
    curl -s https://get.nextflow.io | bash
    echo "Moving nextflow executable to /usr/local/bin"
    chmod +x nextflow
    chmod +r nextflow
    mv nextflow /usr/local/bin/
else
    echo "Nextflow already found."
fi

# --- Install nf-core tools --- 
echo "Installing nf-core tools..."
if ! command -v nf-core &> /dev/null; then
    echo "nf-core tools not found. Installing globally using pip3..."
    pip3 install --upgrade nf-core
    echo "nf-core tools installed successfully."
else
    echo "nf-core tools already found."
fi

# --- Install AWS CLI v2 --- 
echo ""
echo "--- Installing/Updating AWS CLI v2 ---"
if command -v aws &> /dev/null && aws --version | grep -q 'aws-cli/2'; then
    echo "AWS CLI v2 already installed: $(aws --version)"
else
    echo "Installing AWS CLI v2..."
    # Ensure unzip is installed (should be from base prerequisites)
    if ! command -v unzip &> /dev/null; then apt-get install -y unzip; fi
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
    unzip -q /tmp/awscliv2.zip -d /tmp
    # Use install directly, as we are root
    /tmp/aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
    rm -f /tmp/awscliv2.zip
    rm -rf /tmp/aws
    echo "AWS CLI v2 installation complete."
fi
aws --version

# --- Install SSM Agent --- 
echo ""
echo "--- Installing/Ensuring SSM Agent --- "
# Check snap first as it's common on newer Ubuntu
ssm_snap_active=false
if command -v snap &> /dev/null && snap list amazon-ssm-agent &> /dev/null; then
    if systemctl is-active --quiet snap.amazon-ssm-agent.amazon-ssm-agent.service; then
        echo "SSM Agent (Snap) is already installed and active."
        ssm_snap_active=true
    else
        echo "SSM Agent (Snap) found but not active. Attempting to start..."
        systemctl enable --now snap.amazon-ssm-agent.amazon-ssm-agent.service || echo "Failed to start snap SSM Agent."
        if systemctl is-active --quiet snap.amazon-ssm-agent.amazon-ssm-agent.service; then ssm_snap_active=true; fi
    fi
fi

# If snap wasn't active/present, try installing/activating the deb package
if ! $ssm_snap_active; then
    echo "SSM Agent (Snap) not found or inactive. Checking/Installing .deb version..."
    # Check if deb service exists and is active
    if systemctl is-active --quiet amazon-ssm-agent; then
        echo "SSM Agent (.deb) is already installed and active."
    else
        echo "Attempting to install SSM Agent (.deb)..."
        # Ensure wget is installed
        if ! command -v wget &> /dev/null; then apt-get install -y wget; fi
        ARCH=$(dpkg --print-architecture)
        # Need region - try to get from instance metadata, default otherwise
        REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region || echo "us-east-1") 
        SSM_DEB_URL="https://s3.${REGION}.amazonaws.com/amazon-ssm-${REGION}/latest/debian_${ARCH}/amazon-ssm-agent.deb"
        SSM_DEB_TMP="/tmp/amazon-ssm-agent.deb"
        echo "Downloading SSM Agent for $ARCH from $SSM_DEB_URL..."
        wget -q "$SSM_DEB_URL" -O "$SSM_DEB_TMP"
        echo "Installing SSM Agent from $SSM_DEB_TMP..."
        dpkg -i "$SSM_DEB_TMP" || apt --fix-broken install -y # Install or fix dependencies
        rm -f "$SSM_DEB_TMP"
        echo "Enabling and starting SSM Agent service..."
        systemctl enable --now amazon-ssm-agent
    fi
fi

echo "Checking final SSM Agent status..."
systemctl status amazon-ssm-agent --no-pager || snap list amazon-ssm-agent || echo "SSM Agent status check failed or not found."

echo "Adding current user ${USER} to docker group..."
#sudo usermod -aG docker $USER
sudo usermod -aG docker ubuntu ssm-user
sudo usermod -aG docker ssm-user
sudo chmod 666 /var/run/docker.sock
docker run hello-world
#    echo "Adding current user $USER to podman group..."
#    sudo usermod -aG podman $USER

# --- Final Verification Output --- 
echo "--- Verification --- "
java -version || echo "Java verification failed"
python3 --version || echo "Python3 verification failed"
pip3 --version || echo "Pip3 verification failed"
docker --version || echo "Docker verification failed"
docker compose version || echo "Docker Compose verification failed"
podman --version || echo "Podman verification failed"
apptainer --version || echo "Apptainer verification failed"
nextflow -v || echo "Nextflow verification failed"
nf-core --version || echo "nf-core verification failed (Note: exit code may be non-zero even on success)"
aws --version || echo "AWS CLI verification failed"

echo "User Data script finished." 