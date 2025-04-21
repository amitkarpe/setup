#!/usr/bin/env bash

# Installs the 'make' build tool if it's not already present.

set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

if command -v make &> /dev/null; then
    echo "make is already installed: $(make --version | head -n1)"
    exit 0
fi

echo "--- Updating package lists ---"
sudo apt-get update -y

echo ""
echo "--- Installing make ---"
sudo apt-get install -y make

echo ""
echo "make installation finished."
make --version | head -n1 