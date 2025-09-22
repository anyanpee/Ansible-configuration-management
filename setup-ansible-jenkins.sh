#!/bin/bash
<<<<<<< HEAD

# Ansible Jenkins Setup Script
# Run this on your Ubuntu Jenkins server

set -e

echo "=== Ansible Jenkins CI/CD Setup ==="

# Update system
echo "Updating system packages..."
sudo apt update

# Install Ansible
echo "Installing Ansible..."
sudo apt install -y ansible python3-pip git curl

# Install additional Python packages
echo "Installing Python dependencies..."
pip3 install boto3 botocore ansible-lint

# Generate SSH key for Ansible
echo "Generating SSH key for Ansible..."
if [ ! -f ~/.ssh/ansible_key ]; then
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/ansible_key -N ""
    echo "SSH key generated: ~/.ssh/ansible_key"
    echo "Public key:"
    cat ~/.ssh/ansible_key.pub
else
    echo "SSH key already exists"
fi

# Create Jenkins workspace directory
echo "Creating Jenkins workspace..."
sudo mkdir -p /var/lib/jenkins/workspace/ansible-deployment
sudo chown jenkins:jenkins /var/lib/jenkins/workspace/ansible-deployment

# Set up Ansible configuration
echo "Setting up Ansible configuration..."
export ANSIBLE_HOST_KEY_CHECKING=False

# Test Ansible installation
echo "Testing Ansible installation..."
ansible --version

echo ""
echo "=== Setup Complete ==="
echo "Next steps:"
echo "1. Copy SSH public key to target servers:"
echo "   ssh-copy-id -i ~/.ssh/ansible_key.pub user@target-server"
echo "2. Update inventory/hosts with your server IPs"
echo "3. Create Jenkins job with GitHub webhook"
echo "4. Configure webhook URL: http://your-jenkins-ip:8080/github-webhook/"
echo ""
echo "SSH Public Key:"
cat ~/.ssh/ansible_key.pub
=======
set -e
echo "=== Ansible Jenkins CI/CD Setup ==="

# Update system
sudo apt update

# Install Ansible and dependencies via apt (no pip needed)
sudo apt install -y ansible python3-boto3 python3-botocore git curl

# Generate SSH key
if [ ! -f ~/.ssh/ansible_key ]; then
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/ansible_key -N ""
    echo "SSH key generated: ~/.ssh/ansible_key"
fi

# Create Jenkins workspace
sudo mkdir -p /var/lib/jenkins/workspace/ansible-deployment
sudo chown -R $USER:$USER /var/lib/jenkins/workspace/ansible-deployment

# Set environment
export ANSIBLE_HOST_KEY_CHECKING=False

echo "=== Setup Complete ==="
echo "SSH Public Key (copy this to target servers):"
cat ~/.ssh/ansible_key.pub
>>>>>>> 3043089da642f59e7f016ba4a07a7d86c293f958
