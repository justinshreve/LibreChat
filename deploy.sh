#!/bin/bash
set -e  # Exit on any error

echo "Starting deployment at $(date)"
cd /home/ember/LibreChat

echo "Pulling latest code..."
git fetch origin production
git checkout production
git pull origin production

echo "Rebuilding client container..."
docker compose -f deploy-compose.yml build client

echo "Restarting containers..."
docker compose -f deploy-compose.yml up -d

echo "Deployment completed at $(date)"
