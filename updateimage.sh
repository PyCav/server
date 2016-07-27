#!/bin/bash
#update dockerimage

#add to cron ? with $1= jordanosborn/pycav default
#stop server before running
./removeall.sh
docker rmi $1
# $1 build flag -b / image name on dockerhub, $2 docker image name, $3 /path/to/Dockerfile
if [ "$1" -eq "-b" ]; then
	docker build -t $2:latest $3
else
	docker pull $1
fi
