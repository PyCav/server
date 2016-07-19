#!/bin/bash
#if Block I/O doen't change for  some t exit container?
for container in $containers; do
                i=$((i+1))
                if [ $i -gt $iold ]; then
                        newcontainer=$container
                        sudo docker exec $newcontainer
                fi
done