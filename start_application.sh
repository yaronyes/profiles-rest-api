#!/usr/bin/env bash
PROJECT_BASE_PATH='/usr/local/apps/profiles-rest-api'
cd $PROJECT_BASE_PATH
exec sudo docker-compose -f docker-compose.prod.yml up -d