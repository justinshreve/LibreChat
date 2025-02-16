#!/bin/bash
git fetch origin production
git checkout production
git pull origin production
docker compose -f deploy-compose.yml down
docker compose -f deploy-compose.yml build --no-cache api client
docker compose -f deploy-compose.yml up -d
