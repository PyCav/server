#!/bin/bash
cd "${0%/*}"
flag=$1
function run {
    sudo python3 ./python/killcontainers.py "$flag"
}

until run; do
    echo "Killidle crashed with exit code $?.  Respawning.." >&2
    sleep 1
done
