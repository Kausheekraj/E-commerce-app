#!/usr/bin/env bash
if curl -s http://3.133.159.227:80 | grep -q "<title>"; then
  echo "App is up"
  exit 0
else
  echo " App is down"
  exit 1
fi
