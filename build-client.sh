#!/bin/bash
set -e  # Exit on any error

cd /home/ember/LibreChat

# Log file setup
LOG_FILE="build-client.log"
echo "Starting client build at $(date)" > $LOG_FILE

echo "Building client in temporary container..." >> $LOG_FILE
docker run --rm \
  -v $(pwd)/client:/app \
  -w /app \
  node:20-alpine \
  sh -c "npm install && npm run build" >> $LOG_FILE 2>&1

# Capture the exit code
BUILD_STATUS=$?

echo "Build completed at $(date) with status $BUILD_STATUS" >> $LOG_FILE

# Exit with the build status
exit $BUILD_STATUS
