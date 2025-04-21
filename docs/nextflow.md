# Nextflow and nf-core Installation

This document describes how to install Nextflow and the nf-core helper tools using the provided scripts.

## Prerequisites

- Ubuntu Linux
- Basic tools (curl, git, etc. - installed by `scripts/ubuntu.sh`)
- Java 11+ (installed by `scripts/ubuntu.sh`)
- Python 3 and pip3 (installed by `scripts/ubuntu.sh`)

## Installation

To install Nextflow and nf-core, navigate to the `scripts/nextflow` directory and use the Makefile:

```bash
cd scripts/nextflow
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