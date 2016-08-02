#!/bin/bash
function run {
	while true; do
		echo `sudo docker stats --no-stream` > ./.stats.txt
		python3 ./python/serverstats.py
		sleep 3
	done
}

until run; do
    echo "Server Stats crashed with exit code $?.  Respawning.." >&2
    sleep 1
done

