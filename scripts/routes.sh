#!/bin/bash

set -e

if [ $# -eq 0 ]
then
  docker-compose -p pizza-app run --rm web bundle exec rails routes --expanded
else
  docker-compose -p pizza-app run --rm web bundle exec rails routes --expanded -g "$@"
fi
