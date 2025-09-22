#!/bin/bash

# Ansible Jenkins Deployment Script
# This script is executed by Jenkins to deploy configurations

set -e

echo "Starting Ansible deployment..."

# Change to ansible directory
cd ansible

# Test connectivity
echo "Testing Ansible connectivity..."
ansible all -m ping

# Run main playbook
echo "Executing main playbook..."
ansible-playbook -i inventory/hosts playbooks/site.yml -v

# Archive build artifacts
echo "Archiving artifacts..."
mkdir -p /var/lib/jenkins/workspace/ansible-deployment/build-$(date +%Y%m%d-%H%M%S)
cp -r ../ansible /var/lib/jenkins/workspace/ansible-deployment/build-$(date +%Y%m%d-%H%M%S)/

echo "Deployment completed successfully!"