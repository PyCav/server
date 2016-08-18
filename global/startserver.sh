#!/bin/bash
cd /home/public/server
flag=$1
function run {
    sudo ./fixpermissions.sh &
	sudo ./killcontainers.sh "$flag" &
    sudo ./serverstats.sh &
    sudo jupyterhub
}

until run; do
    echo "Server 'jupyter' crashed with exit code $?.  Respawning.." >&2
    sleep 1
done
