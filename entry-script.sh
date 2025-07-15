#!/usr/bin/bash
export FRONTEND_IMAGE=$1
export BACKEND_IMAGE=$2
docker-compose -f docker-compose.yml up -d 