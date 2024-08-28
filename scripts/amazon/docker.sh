#!/usr/bin/bash

set -e
#!/bin/bash

# Update and install basic tools
sudo yum update -y
sudo yum install -y curl git unzip

# Install RustUp
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# Install GitHub CLI
sudo yum install -y https://cli.github.com/packages/githubcli-archive-keyring.noarch.rpm
sudo yum install -y gh

# Install Zellij
cargo install --locked zellij

# Install EXA
cargo install exa

# Install Taskfile
sudo sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

# Print versions of installed tools
echo "Installed tool versions:"
rustc --version
gh --version
zellij --version
exa --version
task --version

echo "Installation complete!"