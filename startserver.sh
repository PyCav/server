#!/bin/bash
cd /home/public/Server
function run {
			   sudo updatecontainers.sh &
			   sudo setupcontainers.sh &
			   sudo killidlecontainers.sh &
               sudo jupyterhub
           }

until run; do
    echo "Server 'jupyter' crashed with exit code $?.  Respawning.." >&2
    sleep 1
done
