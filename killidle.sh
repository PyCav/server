#!/bin/bash
function run {
			   sudo python3 killidle.py
           }

until run; do
    echo "Killidle crashed with exit code $?.  Respawning.." >&2
    sleep 1
done
