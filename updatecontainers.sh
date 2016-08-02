#!/bin/bash
#update dockerimage
#stop server before running
echo "Stopping server"
pkill -f startserver
echo "Stopping and removing all containers"
removecontainers
# $1 build flag -b / -p pull docker hub , $2 docker image name, $3 /path/to/Dockerfile
if [ "$1" == "-b" ]; then
	echo "Removing old image"
	docker rmi $2
	echo "Getting new image"
	docker build -t $2:latest $3
elif [ "$1" == "-p" ]; then
	echo "Removing old image"
	docker rmi $2
	echo "Getting new image"
	docker pull $2
else
	echo "Removing old image"
	docker rmi jordanosborn/pycav
	echo "Getting new image"
	docker pull jordanosborn/pycav
fi
