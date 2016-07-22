#!/bin/bash


function run {
	echo `sudo docker stats --no-stream` > ./stats.txt
	python3 serverstats.py
	sleep 5
           }

until run; do
    echo "Server Stats crashed with exit code $?.  Respawning.." >&2
    sleep 1
done

