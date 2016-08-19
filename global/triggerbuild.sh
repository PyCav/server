#!/bin/bash

curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/jordanosborn/pycav/trigger/c0f580de-d805-4816-b12e-ab2b144eed7a/
if [ "$1" != "--quiet"]; then
  echo $'\nBuild Triggered, ~30 mins to complete.'
  echo "Go to https://hub.docker.com/r/jordanosborn/pycav/builds to see build progress."
fi
