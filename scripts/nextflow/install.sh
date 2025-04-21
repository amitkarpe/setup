#!/usr/bin/env bash

set -euo pipefail
set -x


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
    # No sudo needed for $HOME/.local/bi
    * Share same issue ID for next stepsn
    mv nextflow "$TARGET_BIN/"
    echo "Nextflow installed successfully to $TARGET_BIN/nextflow"
else
    echo "Nextflow already installed: $(nextflow -v)"
fi

echo ""
echo "--- Installing nf-core tools ---"

# Check if nf-core is installed (PATH should include ~/.local/bin now)
if [[ ! -x "$(command -v nf-core)" ]]; then
    echo "nf-core tools not found. Installing using pip3..."
    pip3 install --upgrade --user nf-core # Use --user to ensure install to user location
    echo "nf-core tools installed successfully."
    # Verify after install
    if ! command -v nf-core &> /dev/null; then
       echo "WARNING: nf-core installed but still not found in PATH immediately. You may need to restart your shell or source your profile."
    fi
else
    export PATH="$HOME/.local/bin:$PATH"
    echo "nf-core tools already installed: $(nf-core --version)"
fi

echo ""
echo "--- Installing Apptainer (Singularity) ---"

# Check if Apptainer is installed
if ! command -v apptainer &> /dev/null; then
    echo "Apptainer not found. Installing..."
    APPTAINER_DEB_URL="https://github.com/apptainer/apptainer/releases/download/v1.4.0/apptainer_1.4.0_amd64.deb"
    APPTAINER_DEB_TMP="/tmp/apptainer_1.4.0_amd64.deb"
    echo "Downloading Apptainer from $APPTAINER_DEB_URL..."
    wget "$APPTAINER_DEB_URL" -O "$APPTAINER_DEB_TMP"
    echo "Installing Apptainer from $APPTAINER_DEB_TMP..."
    sudo apt-get update -y # Update apt database before installing local deb
    sudo apt-get install -y "$APPTAINER_DEB_TMP"
    echo "Cleaning up downloaded file..."
    rm -f "$APPTAINER_DEB_TMP"
    echo "Apptainer installed successfully."
else
    echo "Apptainer already installed: $(apptainer --version)"
fi

echo ""
echo "Installation script finished." 
