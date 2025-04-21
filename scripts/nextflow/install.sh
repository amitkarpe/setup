#!/usr/bin/env bash

set -euo pipefail

echo "--- Installing Nextflow ---"

# Check if Nextflow is installed and executable
if [[ ! -x "$(command -v nextflow)" ]]; then
    echo "Nextflow not found or not executable. Installing..."
    # Ensure JAVA_HOME is potentially set for the installation command if needed, although Nextflow's script usually handles this.
    # export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) # Might be needed on some systems
    curl -s https://get.nextflow.io | bash

    # Move to a location in PATH
    # Check if /usr/local/bin exists and is writable, otherwise use ~/.local/bin
    TARGET_BIN=""
    if [[ -d "/usr/local/bin" ]] && [[ -w "/usr/local/bin" ]]; then
        TARGET_BIN="/usr/local/bin"
    elif [[ -d "$HOME/.local/bin" ]]; then
        TARGET_BIN="$HOME/.local/bin"
        # Ensure $HOME/.local/bin is in PATH
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            echo "Adding $HOME/.local/bin to PATH for this session."
            export PATH="$HOME/.local/bin:$PATH"
            # Consider adding to .bashrc/.zshrc if making permanent
        fi
    else
        echo "Error: Could not find a suitable directory (/usr/local/bin or ~/.local/bin) to install Nextflow."
        echo "Please create ~/.local/bin and ensure it's in your PATH."
        exit 1
    fi

    echo "Moving nextflow executable to $TARGET_BIN"
    chmod +x nextflow
    sudo mv nextflow "$TARGET_BIN/" # Use sudo if moving to /usr/local/bin
    echo "Nextflow installed successfully to $TARGET_BIN/nextflow"
else
    echo "Nextflow already installed: $(nextflow -v)"
fi

echo ""
echo "--- Installing nf-core tools ---"

# Check if nf-core is installed
if ! command -v nf-core &> /dev/null; then
    echo "nf-core tools not found. Installing using pip3..."
    # Consider using a virtual environment
    # python3 -m venv ~/.nf-core-venv
    # source ~/.nf-core-venv/bin/activate
    pip3 install --upgrade nf-core
    # Deactivate if using venv: deactivate
    echo "nf-core tools installed successfully."
else
    echo "nf-core tools already installed: $(nf-core --version)"
fi

echo ""
echo "Installation script finished." 