#!/bin/bash

set -e

echo
echo "Updating 'web' with new environment variables from .env..."
docker-compose -p pizza-app up -d web
