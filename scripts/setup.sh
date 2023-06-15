#!/bin/bash

set -e

echo "########################"
echo "Pizza App Docker Setup"
echo "########################"

echo
echo "Copying '.env.example' to '.env'..."
cp -n .env.example .env || : # No clobber (-n) on macOS doesn't have an exit code of 0

echo
echo "Building the 'pizza-app' Docker image..."
docker-compose -p pizza-app build --no-cache

echo
echo "Building the 'piza-app' Docker services..."
docker-compose -p pizza-app up
