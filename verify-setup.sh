#!/bin/bash

# Verification Script for Ansible Jenkins Setup

echo "=== Ansible Jenkins Setup Verification ==="

# Check Ansible installation
echo "1. Checking Ansible installation..."
if command -v ansible &> /dev/null; then
    echo "✅ Ansible installed: $(ansible --version | head -1)"
else
    echo "❌ Ansible not found"
fi

# Check SSH key
echo "2. Checking SSH key..."
if [ -f ~/.ssh/ansible_key ]; then
    echo "✅ SSH key exists: ~/.ssh/ansible_key"
else
    echo "❌ SSH key not found"
fi

# Check Ansible configuration
echo "3. Checking Ansible configuration..."
if [ -f ansible/ansible.cfg ]; then
    echo "✅ Ansible config found"
else
    echo "❌ Ansible config missing"
fi

# Check inventory
echo "4. Checking inventory..."
if [ -f ansible/inventory/hosts ]; then
    echo "✅ Inventory file found"
    echo "Hosts configured:"
    grep -E "^[a-z]" ansible/inventory/hosts | head -5
else
    echo "❌ Inventory file missing"
fi

# Test connectivity (if possible)
echo "5. Testing Ansible connectivity..."
cd ansible 2>/dev/null
if ansible all -m ping --timeout=5 2>/dev/null | grep -q SUCCESS; then
    echo "✅ Ansible connectivity successful"
else
    echo "⚠️  Ansible connectivity test failed (check SSH keys and target servers)"
fi

# Check Jenkins workspace
echo "6. Checking Jenkins workspace..."
if [ -d "/var/lib/jenkins/workspace" ]; then
    echo "✅ Jenkins workspace exists"
else
    echo "⚠️  Jenkins workspace not found (may need sudo access)"
fi

echo ""
echo "=== Verification Complete ==="
echo "Next: Push changes to GitHub to trigger Jenkins build"