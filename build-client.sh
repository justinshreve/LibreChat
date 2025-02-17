#!/bin/bash
set -e  # Exit on any error

echo "Starting client build at $(date)"
cd /home/ember/LibreChat

echo "Building client in temporary container..."
docker run --rm \
  -v $(pwd)/client:/app \
  -w /app \
  node:20-alpine \
  sh -c "npm install && npm run build"

echo "Deployment completed at $(date)"
