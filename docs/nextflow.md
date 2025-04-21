# Nextflow and nf-core Installation

This document describes how to install Nextflow and the nf-core helper tools using the provided scripts.

## Prerequisites

Using the Makefile targets requires the `make` command to be installed.
Dependencies can be installed using the dedicated script in this directory.

1.  Navigate to the `scripts/nextflow` directory.
2.  Run the dependency installation target:

    ```bash
    cd scripts/nextflow
    make install-deps
    ```

This executes `install_deps.sh`, which ensures the following are installed on an Ubuntu system:
- Basic tools (curl, git, wget, jq, make, etc.)
- Java 11 (OpenJDK)
- Python 3, pip3, and venv

## Installation

Once prerequisites are installed, you can install Nextflow and nf-core.

1. Ensure you are in the `scripts/nextflow` directory.
2. Run the installation target:

    ```bash
    make install
    ```

This will run the `install.sh` script, which performs the following actions:

1.  Downloads and installs the latest stable version of Nextflow using the official `get.nextflow.io` script.
2.  Moves the `nextflow` executable to `/usr/local/bin` (or `~/.local/bin` if the former is not writable).
3.  Installs the latest version of `nf-core` using `pip3`.

Both installations are idempotent, meaning they will check if the tools already exist before attempting installation.

## Testing

To verify the installation, run the test target from the `scripts/nextflow` directory:

```bash
cd scripts/nextflow
make test
```

This executes `test.sh`, which checks:

- If the `nextflow` command is available and runs `nextflow -v`.
- If the `nf-core` command is available and runs `nf-core --version`.

The script will report success or failure based on these checks. 