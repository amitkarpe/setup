SHELL := /bin/bash

.PHONY: launch delete help

# Variable for delete target
INSTANCE_ID ?= ""

launch:
	@echo "Running EC2 launch script..."
	@bash launch_ec2.sh

# Target to delete an instance
delete:
	@if [ -z "$(INSTANCE_ID)" ]; then \
		echo "Error: INSTANCE_ID must be set. Usage: make delete INSTANCE_ID=i-xxxxxxxxxxxxxxxxx"; \
		exit 1; \
	fi
	@echo "Running EC2 deletion script for instance $(INSTANCE_ID)..."
	@bash delete_ec2.sh "$(INSTANCE_ID)"

help:
	@echo "Makefile for AWS EC2 operations"
	@echo ""
	@echo "Usage:"
	@echo "  make launch             - Launch a new EC2 instance based on launch_ec2.sh"
	@echo "  make delete INSTANCE_ID=<id> - Terminate the specified EC2 instance"
	@echo "  make help               - Show this help message" 