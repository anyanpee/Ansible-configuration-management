#!/bin/bash

# Ansible Jenkins Deployment Script
set -e

echo "Starting Ansible deployment..."

# Change to ansible directory
cd ansible

# Create localhost inventory for Jenkins demo
cat > inventory/localhost.yml << 'INVENTORY_EOF'
[webservers]
localhost ansible_connection=local

[all:vars]
ansible_python_interpreter=/usr/bin/python3
INVENTORY_EOF

# Create simple localhost playbook
cat > playbooks/localhost-demo.yml << 'PLAYBOOK_EOF'
---
- name: Jenkins Ansible Demo
  hosts: localhost
  become: yes
  tasks:
    - name: Create demo file
      copy:
        content: "Jenkins Ansible deployment successful"
        dest: /tmp/jenkins-ansible-demo.txt
    
    - name: Show success message
      debug:
        msg: "Deployment completed successfully!"
PLAYBOOK_EOF

# Test connectivity
echo "Testing Ansible connectivity..."
ansible localhost -i inventory/localhost.yml -m ping

# Run playbook
echo "Executing demo playbook..."
ansible-playbook -i inventory/localhost.yml playbooks/localhost-demo.yml -v

echo "Deployment completed successfully!"

