#!/usr/bin/env bash

set -euo pipefail

# Ensure $HOME/.local/bin exists and is in the PATH for this script
if [[ ! -d "$HOME/.local/bin" ]]; then
    echo "Creating directory $HOME/.local/bin"
    mkdir -p "$HOME/.local/bin"
fi
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "Adding $HOME/.local/bin to PATH for this session."
    export PATH="$HOME/.local/bin:$PATH"
    # Note: For permanent addition, user should add to ~/.bashrc or ~/.profile
    echo "export PATH=\"$HOME/.local/bin:$PATH\"" >> ~/.bashrc
fi

echo "--- Installing Nextflow ---"

# Check if Nextflow is installed and executable
if [[ ! -x "$(command -v nextflow)" ]]; then
    echo "Nextflow not found or not executable. Installing..."
    # Ensure JAVA_HOME is potentially set for the installation command if needed, although Nextflow's script usually handles this.
    # export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) # Might be needed on some systems
    curl -s https://get.nextflow.io | bash

    # Always target $HOME/.local/bin now that we ensured it exists
    TARGET_BIN="$HOME/.local/bin"
    
    echo "Moving nextflow executable to $TARGET_BIN"
    chmod +x nextflow
    # No sudo needed for $HOME/.local/bin
    mv nextflow "$TARGET_BIN/"
    echo "Nextflow installed successfully to $TARGET_BIN/nextflow"
else
    echo "Nextflow already installed: $(nextflow -v)"
fi

echo ""
echo "--- Installing nf-core tools ---"

# Check if nf-core is installed (PATH should include ~/.local/bin now)
if ! command -v nf-core &> /dev/null; then
    echo "nf-core tools not found. Installing using pip3..."
    pip3 install --upgrade --user nf-core # Use --user to ensure install to user location
    echo "nf-core tools installed successfully."
    # Verify after install
    if ! command -v nf-core &> /dev/null; then
       echo "WARNING: nf-core installed but still not found in PATH immediately. You may need to restart your shell or source your profile."
    fi
else
    echo "nf-core tools already installed: $(nf-core --version)"
fi

echo ""
echo "Installation script finished." 