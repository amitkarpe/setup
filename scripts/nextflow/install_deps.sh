#!/usr/bin/env bash

# Installs all prerequisites for Nextflow, nf-core, Apptainer, and Container Tools

set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

echo "--- Updating package lists ---"
sudo apt-get update -y

# --- Install Docker using Convenience Script ---
if [[ ! -x "$(command -v docker)" ]]; then
    echo "Installing Docker using get.docker.com script..."
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sudo sh /tmp/get-docker.sh
    rm /tmp/get-docker.sh
    echo "Adding current user $USER to docker group..."
    sudo usermod -aG docker $USER
    echo "Docker installed. You may need to start a new shell for group changes to take effect."
else
    echo "Docker command found, skipping installation via script."
fi

echo ""
echo "--- Installing Other Prerequisites ---"

# Combine all remaining package installations into one command
sudo apt-get install -y --no-install-recommends \
    tree \
    tmux \
    nano \
    unzip \
    vim \
    wget \
    git \
    net-tools \
    zsh \
    htop \
    jq \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    openjdk-21-jdk \
    python3 \
    python3-pip \
    python3-venv \
    make \
    software-properties-common \
    golang \
    podman \
    buildah \
    skopeo \
    awscli \
    squashfs-tools \
    fuse2fs \
    s3fs

# --- Verifying installations --- #
# (Keep verifications as they are useful)

echo ""
echo "--- Verifying container tool installations ---"
docker --version || echo "Docker verification failed"
docker compose version || echo "Docker Compose verification failed"
docker buildx version || echo "Docker Buildx verification failed"
podman --version || echo "Podman verification failed"
buildah --version || echo "Buildah verification failed"
skopeo --version || echo "Skopeo verification failed"

# ... (other verification commands like java, python, aws) ...
java -version
python3 --version
pip3 --version
aws --version
# aws s3 ls # Removed potentially interactive/error-prone check

# --- Install AWS CLI v2 --- 
echo ""
echo "--- Installing/Updating AWS CLI v2 ---"
if command -v aws &> /dev/null && aws --version | grep -q 'aws-cli/2'; then
    echo "AWS CLI v2 already installed: $(aws --version)"
else
    echo "Installing AWS CLI v2..."
    # Ensure unzip is installed (should be from base prerequisites)
    if ! command -v unzip &> /dev/null; then sudo apt-get install -y unzip; fi
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
    unzip -q /tmp/awscliv2.zip -d /tmp
    sudo /tmp/aws/install --update
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
    if sudo systemctl is-active --quiet snap.amazon-ssm-agent.amazon-ssm-agent.service; then
        echo "SSM Agent (Snap) is already installed and active."
        ssm_snap_active=true
    else
        echo "SSM Agent (Snap) found but not active. Attempting to start..."
        sudo systemctl enable --now snap.amazon-ssm-agent.amazon-ssm-agent.service || echo "Failed to start snap SSM Agent."
        if sudo systemctl is-active --quiet snap.amazon-ssm-agent.amazon-ssm-agent.service; then ssm_snap_active=true; fi
    fi
fi

# If snap wasn't active/present, try installing/activating the deb package
if ! $ssm_snap_active; then
    echo "SSM Agent (Snap) not found or inactive. Checking/Installing .deb version..."
    # Check if deb service exists and is active
    if sudo systemctl is-active --quiet amazon-ssm-agent; then
        echo "SSM Agent (.deb) is already installed and active."
    else
        echo "Attempting to install SSM Agent (.deb)..."
        # Ensure wget is installed
        if ! command -v wget &> /dev/null; then sudo apt-get install -y wget; fi
        ARCH=$(dpkg --print-architecture)
        # Need region - try to get from instance metadata, default otherwise
        REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region || echo "us-east-1") 
        SSM_DEB_URL="https://s3.${REGION}.amazonaws.com/amazon-ssm-${REGION}/latest/debian_${ARCH}/amazon-ssm-agent.deb"
        SSM_DEB_TMP="/tmp/amazon-ssm-agent.deb"
        echo "Downloading SSM Agent for $ARCH from $SSM_DEB_URL..."
        wget -q "$SSM_DEB_URL" -O "$SSM_DEB_TMP"
        echo "Installing SSM Agent from $SSM_DEB_TMP..."
        sudo dpkg -i "$SSM_DEB_TMP" || sudo apt --fix-broken install -y # Install or fix dependencies
        rm -f "$SSM_DEB_TMP"
        echo "Enabling and starting SSM Agent service..."
        sudo systemctl enable --now amazon-ssm-agent
    fi
fi

echo "Checking final SSM Agent status..."
sudo systemctl status amazon-ssm-agent --no-pager || snap list amazon-ssm-agent || echo "SSM Agent status check failed or not found."

# --- Final User Management --- 

# Add user to podman group if podman command exists AND the group exists
if [[ -x "$(command -v podman)" ]]; then
    if getent group podman &> /dev/null; then
        echo "Adding current user $USER to podman group..."
        sudo usermod -aG podman $USER
    else
        echo "Note: 'podman' group does not exist. Skipping user addition to group."
        # If you need rootless podman to work with specific group permissions,
        # the 'podman' group might need to be created manually by an administrator.
    fi
fi

echo ""
echo "Prerequisite installation script finished."
# Note: User might need to start a new shell or log out/in for group memberships (docker, podman) to apply.
