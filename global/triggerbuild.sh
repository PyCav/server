#!/bin/bash

cd /home/public/
if [ "$1" == "--status" ]; then
	python3 ./server/python/buildstatus.py
else
	curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/jordanosborn/pycav/trigger/c0f580de-d805-4816-b12e-ab2b144eed7a/
	echo $'\nBuild Triggered, ~30 mins to complete.'
fi
