# Ansible Jenkins CI/CD Implementation Guide

## Step 1: Setup Ansible on Jenkins Server

### On your Ubuntu Jenkins server, run:

```bash
# Make setup script executable and run
chmod +x setup-ansible-jenkins.sh
./setup-ansible-jenkins.sh
```

## Step 2: Configure SSH Access to Target Servers

```bash
# Copy SSH public key to each target server
ssh-copy-id -i ~/.ssh/ansible_key.pub ec2-user@172.31.33.248  # Web1
ssh-copy-id -i ~/.ssh/ansible_key.pub ec2-user@172.31.38.180  # Web2
ssh-copy-id -i ~/.ssh/ansible_key.pub ec2-user@172.31.47.119  # DB/LB
ssh-copy-id -i ~/.ssh/ansible_key.pub ec2-user@172.31.32.100  # NFS

# Test connectivity
ansible all -m ping
```

## Step 3: Create Jenkins Job

### Method 1: Jenkins Web UI
1. Go to Jenkins Dashboard → New Item
2. Enter name: `ansible-deployment`
3. Select "Freestyle project"
4. Configure:
   - **Source Code Management**: Git
   - **Repository URL**: Your GitHub repo URL
   - **Branch**: `*/main`
   - **Build Triggers**: ✅ GitHub hook trigger for GITScm polling
   - **Build Steps**: Execute shell
   ```bash
   cd ansible-jenkins-automation
   chmod +x scripts/deploy.sh
   ./scripts/deploy.sh
   ```
   - **Post-build Actions**: Archive artifacts `**/*`

### Method 2: Jenkins CLI (Alternative)
```bash
# Create job from XML config
java -jar jenkins-cli.jar -s http://localhost:8080 create-job ansible-deployment < jenkins-job-config.xml
```

## Step 4: Configure GitHub Webhook

1. Go to your GitHub repository → Settings → Webhooks
2. Click "Add webhook"
3. Configure:
   - **Payload URL**: `http://YOUR-JENKINS-IP:8080/github-webhook/`
   - **Content type**: `application/json`
   - **Which events**: Just the push event
   - **Active**: ✅ Checked

## Step 5: Test the Pipeline

### Test Ansible connectivity:
```bash
cd ansible-jenkins-automation/ansible
ansible all -m ping -i inventory/hosts
```

### Test playbook execution:
```bash
ansible-playbook -i inventory/hosts test-deployment.yml
```

### Test Jenkins integration:
1. Make a change to any file in your repository
2. Commit and push to main branch:
```bash
git add .
git commit -m "Test Jenkins webhook trigger"
git push origin main
```
3. Check Jenkins dashboard for triggered build
4. Verify artifacts in `/var/lib/jenkins/workspace/ansible-deployment/`

## Step 6: Verify Deployment

### Check Jenkins workspace:
```bash
ls -la /var/lib/jenkins/workspace/ansible-deployment/
```

### Check web servers:
```bash
# Test web server deployment
curl http://172.31.33.248
curl http://172.31.38.180

# Test load balancer
curl http://172.31.47.119
```

## Troubleshooting

### Common Issues:

1. **SSH Connection Failed**
   ```bash
   # Check SSH key permissions
   chmod 600 ~/.ssh/ansible_key
   
   # Test manual SSH
   ssh -i ~/.ssh/ansible_key ec2-user@target-ip
   ```

2. **Ansible Host Key Checking**
   ```bash
   export ANSIBLE_HOST_KEY_CHECKING=False
   ```

3. **Jenkins Permission Issues**
   ```bash
   sudo chown -R jenkins:jenkins /var/lib/jenkins/workspace/
   ```

4. **Webhook Not Triggering**
   - Check GitHub webhook delivery logs
   - Verify Jenkins URL is accessible from internet
   - Check Jenkins system log for webhook events

## File Locations

- **Ansible Config**: `ansible/ansible.cfg`
- **Inventory**: `ansible/inventory/hosts`
- **Main Playbook**: `ansible/playbooks/site.yml`
- **Jenkins Artifacts**: `/var/lib/jenkins/workspace/ansible-deployment/`
- **Build Logs**: Jenkins Web UI → Build History

## Success Indicators

✅ **Ansible connectivity test passes**  
✅ **Jenkins job created successfully**  
✅ **GitHub webhook configured**  
✅ **Push to main branch triggers build**  
✅ **Build artifacts saved to Jenkins workspace**  
✅ **Target servers configured via Ansible**