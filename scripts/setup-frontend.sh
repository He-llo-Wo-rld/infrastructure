#!/bin/bash
# Frontend EC2 user_data script (runs on first boot)
# Installs: Docker, Docker Compose, Git
# After boot, manually install: Nginx, Certbot (Let's Encrypt)
set -e

yum update -y

# Docker
yum install -y docker
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user

# Docker Compose
DOCKER_COMPOSE_VERSION="v2.29.0"
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Git
yum install -y git

echo "=== Frontend EC2 setup complete! ==="
