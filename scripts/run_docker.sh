#!/usr/bin/env bash

## Complete the following steps to get Docker running locally

# Load configurations
. ./scripts/config.sh

# Build image
docker build --build-arg APP_PORT=$PORT --tag=$dockerpath .

# Run flask app
docker run -e "PORT=$PORT" -p $LOCAL_PORT:$PORT $dockerpath