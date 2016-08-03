#!/bin/bash

pkill -f startserver
pkill -f jupyterhub
pkill -f fixpermissions.sh
pkill -f killcontainers.sh
pkill -f serverstats.sh
pkill -f python3
