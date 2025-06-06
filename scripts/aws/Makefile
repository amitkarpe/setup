SHELL := /bin/bash

.PHONY: launch launch-from-file delete help

# Variables for targets
ENV_FILE ?= ""
INSTANCE_ID ?= ""

# Target for hardcoded launch
launch:
	@echo "Running EC2 launch script (hardcoded values)..."
	@bash launch_ec2.sh

# Target for launch from env file
launch-from-file:
	@if [ -z "$(ENV_FILE)" ]; then \
		echo "Error: ENV_FILE must be set. Usage: make launch-from-file ENV_FILE=path/to/your.env"; \
		exit 1; \
	fi
	@echo "Running EC2 launch script with config from $(ENV_FILE)..."
	@bash launch_ec2_from_file.sh "$(ENV_FILE)"

# Target to delete an instance
delete:
	@if [ -z "$(INSTANCE_ID)" ]; then \
		echo "Error: INSTANCE_ID must be set. Usage: make delete INSTANCE_ID=<id>"; \
		exit 1; \
	fi
	@echo "Running EC2 deletion script for instance $(INSTANCE_ID)..."
	@bash delete_ec2.sh "$(INSTANCE_ID)"

help:
	@echo "Makefile for AWS EC2 operations"
	@echo ""
	@echo "Usage:"
	@echo "  make launch                  - Launch EC2 instance using hardcoded values in launch_ec2.sh"
	@echo "  make launch-from-file ENV_FILE=<path> - Launch EC2 instance using config from <path>"
	@echo "  make delete INSTANCE_ID=<id> - Terminate the specified EC2 instance"
	@echo "  make help                  - Show this help message" 