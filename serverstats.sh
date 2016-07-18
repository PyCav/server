#!/bin/bash
while true; do
        echo `sudo docker stats --no-stream -a` > ./stats.txt
        sleep 10
done