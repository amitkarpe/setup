SHELL := /bin/bash

.PHONY: all install test clean help

all: install test

install:
	@echo "Running installation script..."
	@bash install.sh

test:
	@echo "Running test script..."
	@bash test.sh

clean:
	@echo "Cleaning up... (No specific cleanup actions defined yet)"

help:
	@echo "Makefile for Nextflow/nf-core setup"
	@echo ""
	@echo "Usage:"
	@echo "  make install   - Install Nextflow and nf-core tools"
	@echo "  make test      - Run tests to verify installation"
	@echo "  make all       - Run install and then test"
	@echo "  make clean     - Clean up (currently does nothing)"
	@echo "  make help      - Show this help message" 