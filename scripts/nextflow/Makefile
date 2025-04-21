SHELL := /bin/bash

.PHONY: all install install-deps test clean help

all: install-deps install test

install:
	@echo "Running Nextflow/nf-core installation script..."
	@bash install.sh

# New target to install dependencies
install-deps:
	@echo "Running prerequisite installation script..."
	@bash install_deps.sh

test:
	@echo "Running test script..."
	@bash test.sh

clean:
	@echo "Cleaning up... (No specific cleanup actions defined yet)"

help:
	@echo "Makefile for Nextflow/nf-core setup"
	@echo ""
	@echo "Usage:"
	@echo "  make install-deps - Install system prerequisites (Java, Python, etc.)"
	@echo "  make install    - Install Nextflow and nf-core tools (requires deps first)"
	@echo "  make test       - Run tests to verify installation"
	@echo "  make all        - Run install and then test"
	@echo "  make clean      - Clean up (currently does nothing)"
	@echo "  make help       - Show this help message" 