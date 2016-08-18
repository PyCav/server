#!/bin/bash
#update dockerimage
#stop server before running
cd /home/public/server
echo "Stopping server"
killserver
echo "Stopping and removing all containers"
removecontainers
# $1 build flag -b / -p pull docker hub , $2 docker image name, $3 /path/to/Dockerfile
if [ "$1" == "-b" ]; then
	echo "Removing old image"
	if [ $# -eq 1 ]; then
		docker rmi jordanosborn/pycav
		echo "Building new image"
		docker build -t  jordanosborn/pycav:latest ./dockerimage/
	else
		if [ $# -eq 2 ]; then
			docker rmi $2
			echo "Building new image"
			docker build -t $2:latest ./dockerimage/
		else
			docker rmi $2
			echo "Building new image"
			docker build -t $2:latest $3
		fi
	fi
elif [ "$1" == "-p" ]; then
	echo "Removing old image"
	if [ $# -eq 1 ]; then
		docker rmi jordanosborn/pycav
		echo "Getting new image"
		docker pull jordanosborn/pycav
	else
		docker rmi $2
		echo "Getting new image"
		docker pull $2
	fi
else
	echo "Removing old image"
	docker rmi jordanosborn/pycav
	echo "Getting new image"
	docker pull jordanosborn/pycav
fi
