#!/bin/bash

set -e

echo
echo "Rebuilding the 'web' image according to latest DOCKERFILE..."
docker-compose -p pizza-app build --no-cache
