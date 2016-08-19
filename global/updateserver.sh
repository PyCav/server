#!/bin/bash

#$2 image name $3 dockerfile path

cd /home/public/
killserver
updatescripts
./server/cron/updatenotebooks.sh

if [ "$1" == "-b" ]; then
	updatecontainers -b "$2" "$3"
elif [ "$1" == "-p" ]; then
	updatecontainers -p "$2"
elif [ "$1" == "-f" ]; then
	triggerbuild
	python3 ./server/python/buildstatus.py --stream
	updatecontainers
else
	updatecontainers
fi
