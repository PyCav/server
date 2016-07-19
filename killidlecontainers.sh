#!/bin/bash

while true; do
	containers=$(sudo docker ps -a | awk '{if(NR>1) print $NF}')
	for container in $containers; do
        pid=`docker inspect --format '{{ .State.Pid }}' jupyter-jo357`
        .

	done
done
