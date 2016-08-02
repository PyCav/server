#!/bin/bash
function run {
    sudo python3 ./python/killcontainers.py $1
}

until run; do
    echo "Killidle crashed with exit code $?.  Respawning.." >&2
    sleep 1
done
