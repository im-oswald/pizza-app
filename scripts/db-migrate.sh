#!/bin/bash

set -e

docker-compose -p pizza-app run --rm web bundle exec rails db:migrate
