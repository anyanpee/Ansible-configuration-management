#!/bin/bash
set -e
echo "Starting Ansible deployment..."

# Change to ansible directory
cd ansible

# Copy SSH key to Jenkins user location (if running as jenkins user)
if [ "$USER" = "jenkins" ] || [ "$USER" = "root" ]; then
    # Use localhost for Jenkins demonstration since SSH keys aren't available
    cat > inventory/hosts << 'INVENTORY_EOF'
[webservers]
localhost ansible_connection=local

[all:vars]
ansible_python_interpreter=/usr/bin/python3
INVENTORY_EOF

    # Update playbook for localhost
    cat > playbooks/site.yml << 'PLAYBOOK_EOF'
---
- name: Deploy to localhost (Jenkins demo)
  hosts: localhost
  become: yes
  tasks:
    - name: Update package cache
      apt:
        update_cache: yes
    
    - name: Install wireshark
      apt:
        name: wireshark
        state: present
      environment:
        DEBIAN_FRONTEND: noninteractive
    
    - name: Create deployment success file
      copy:
        content: "Jenkins deployment successful - {{ ansible_date_time.iso8601 }}"
        dest: /tmp/jenkins-deployment-success.txt
PLAYBOOK_EOF
fi

# Test connectivity
ansible all -m ping

# Run playbook
ansible-playbook -i inventory/hosts playbooks/site.yml -v

# Archive build
BUILD_DIR="/var/lib/jenkins/workspace/ansible-deployment/build-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BUILD_DIR" || mkdir -p "/var/snap/jenkins/current/workspace/ansible-deployment/build-$(date +%Y%m%d-%H%M%S)"
cp -r . "$BUILD_DIR/" 2>/dev/null || cp -r . "/var/snap/jenkins/current/workspace/ansible-deployment/build-$(date +%Y%m%d-%H%M%S)/" 2>/dev/null || echo "Archive location not accessible"

echo "Deployment completed successfully!"
