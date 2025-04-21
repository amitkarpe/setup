#!/usr/bin/env bash

# Installs all prerequisites for Nextflow and nf-core on a fresh Ubuntu system.

set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

echo "--- Updating package lists ---"
sudo apt-get update -y

echo ""
echo "--- Installing Prerequisites (Basic Tools, Java 11, Python3/Pip) ---"

# Combine all package installations into one command
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
    docker-ce \
    podman \
    buildah \
    skopeo \
    conda \
    awscli \
    squashfs-tools \
    fuse2fs \
    s3fs
    

# Add user to docker group
sudo usermod -aG docker $USER
sudo systemctl status docker
sudo docker run hello-world

# Add user to podman group
sudo usermod -aG podman $USER
sudo systemctl status podman
sudo podman run hello-world

# Test AWS CLI
aws --version
aws s3 ls

# --- Add Docker Official Repository --- 
if ! command -v docker &> /dev/null; then
    echo "Setting up Docker repository..."
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
else
    echo "Docker command found, assuming repository is already set up or Docker is installed differently."
fi

echo ""
echo "--- Installing Packages ---"

# Combine all package installations into one command
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
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    podman \
    buildah \
    skopeo \
    conda \
    awscli \
    squashfs-tools \
    fuse2fs \
    s3fs

echo ""
echo "--- Verifying container tool installations ---"
docker --version || echo "Docker verification failed"
docker compose version || echo "Docker Compose verification failed"
docker buildx version || echo "Docker Buildx verification failed"
podman --version || echo "Podman verification failed"
buildah --version || echo "Buildah verification failed"
skopeo --version || echo "Skopeo verification failed"
