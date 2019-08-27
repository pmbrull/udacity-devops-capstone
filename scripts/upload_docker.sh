#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Load configurations
. ./scripts/config.sh

# Authenticate & tag
echo "Docker ID and Image: $dockerpath"

# Get imageId from one tag, e.g., latest
imageId=$(docker images -q $dockerpath:latest)

docker tag $imageId $dockerpath:$version

# Push image to a docker repository
docker push $dockerpath