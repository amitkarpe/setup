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
