#!/bin/bash

set -e

docker-compose -p pizza-app run --rm web "$@"
