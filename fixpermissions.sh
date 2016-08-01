#!/bin/bash

function run {
	while true; do
		chmod -R a+rxw /home/public/users
		sleep 2
	done
           }

until run; do
    echo "FixPermissions crashed with exit code $?.  Respawning.." >&2
    sleep 1
done


