#!/bin/bash
set -e
echo "Starting Ansible deployment..."
cd ansible
ansible all -m ping
ansible-playbook -i inventory/hosts playbooks/site.yml -v
mkdir -p /var/lib/jenkins/workspace/ansible-deployment/build-$(date +%Y%m%d-%H%M%S)
cp -r . /var/lib/jenkins/workspace/ansible-deployment/build-$(date +%Y%m%d-%H%M%S)/
echo "Deployment completed!"
