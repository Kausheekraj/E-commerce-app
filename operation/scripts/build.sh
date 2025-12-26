#!/usr/bin/env bash
set -e

MODE="build"
ENV="$1"
shift

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p) MODE="push" ;;              
  esac
  shift
done

IMAGE_NAME="kausheekraj/ecommerce-nginx:${ENV}"

case "$MODE" in
  build)
    echo ">>>>> Building image: $IMAGE_NAME"
    docker compose build "$ENV"
    ;;
  push)
    echo ">>>>> Pushing image: $IMAGE_NAME"
    docker compose push "$ENV"
   ;;
esac

