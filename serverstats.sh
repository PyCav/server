#!/bin/bash
while true; do
        echo `sudo docker stats --no-stream -a` > ./stats.txt
        python3 formatting.py
        sleep 5
done
