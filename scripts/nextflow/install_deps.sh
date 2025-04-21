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
    make

echo ""
echo "--- Verifying installations ---"
java -version
python3 --version
pip3 --version

echo ""
echo "Prerequisite installation script finished." 