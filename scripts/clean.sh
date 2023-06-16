#!/bin/bash

set -e

echo
echo "#########################"
echo "Pizza App Docker Cleanup"
echo "#########################"
echo
echo "## Heads up! ##"
echo
echo "Running this script will completely wipe the Docker development setup from your machine!"
echo "This includes all containers, the 'web' image and all data volumes."
echo
echo "Are you sure you want to proceed? Type 'pizza' to continue..."
echo

read CONFIRM
echo

if [ "$CONFIRM" == "pizza" ]; then
  echo "Stopping / Removing the Docker services and volumes..."
  docker-compose -p pizza-app down --volumes

  echo
  echo "Removing the 'web' Docker image..."
  docker image rm pizza-app_web --force

  DANGLING_IMAGES=$(docker images -f "dangling=true" -q)

  if [ ! -z "$DANGLING_IMAGES" ] ; then
    echo
    echo "Removing dangling Docker images..."
    docker rmi $DANGLING_IMAGES
  fi

  echo
  echo "Done cleaning the Docker development setup!"
else
  echo "Invalid confirmation! Aborting..."
fi
