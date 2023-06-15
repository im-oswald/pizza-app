#!/bin/bash

set -e

echo
echo "Starting the 'pizza' Docker services..."
docker-compose -p pizza-app start
