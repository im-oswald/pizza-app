#!/bin/bash

set -e

echo
echo "Stopping the 'pizza-app' Docker services..."
docker-compose -p pizza-app stop
