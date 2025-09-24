#!/bin/bash

# Ansible Jenkins Deployment Script
set -e

echo "Starting Ansible deployment..."

# Change to ansible directory
cd ansible

# Test connectivity
echo "Testing Ansible connectivity..."
ansible all -m ping

# Run playbook
echo "Executing main playbook..."
ansible-playbook -i inventory/dev.yml playbooks/site.yml -v

# Archive build
echo "Archiving artifacts..."
BUILD_DIR="/var/lib/jenkins/workspace/ansible-deployment/build-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BUILD_DIR" 2>/dev/null || mkdir -p "/var/snap/jenkins/current/workspace/ansible-deployment/build-$(date +%Y%m%d-%H%M%S)" 2>/dev/null || echo "Archive location not accessible"
cp -r . "$BUILD_DIR/" 2>/dev/null || cp -r . "/var/snap/jenkins/current/workspace/ansible-deployment/build-$(date +%Y%m%d-%H%M%S)/" 2>/dev/null || echo "Copy failed"

echo "Deployment completed successfully!"
