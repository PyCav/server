#!/bin/bash
cd /home/public/server
function run {
    sudo ./fixpermissions.sh &
    if [ "$1" -ne "-nk" ]; then
		sudo ./killidle.sh &
	fi
    sudo ./serverstats.sh &
    sudo ./jupyterhub
}

until run; do
    echo "Server 'jupyter' crashed with exit code $?.  Respawning.." >&2
    sleep 1
done
