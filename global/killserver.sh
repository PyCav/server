#!/bin/bash

pkill -f startserver
#pkill -SIGINT jupyterhub? to kill nicely
pkill -f jupyterhub
pkill -f fixpermissions.sh
pkill -f killcontainers.sh
pkill -f serverstats.sh
#does this need to happen?
pkill -f python3
