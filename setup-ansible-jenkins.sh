#!/bin/bash
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
