#!/bin/bash

set -e

docker-compose -p pizza-app run -e RAILS_ENV=test --rm web bundle exec rake db:migrate
docker-compose -p pizza-app run -e RAILS_ENV=test --rm web bundle exec rspec -f documentation "$@"
