#!/bin/bash
DOCKER_BUILDKIT=1
docker build \
  --progress=plain \
  --no-cache \
  -t my-website:1.0.0 .
