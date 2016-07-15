#!/bin/bash
while true; do
        sleep 1
        containers=$(sudo docker ps -a | awk '{if(NR>1) print $NF}')
        iold=$i
        i=0
        for container in $containers; do
                        i=$((i+1))
                        if (( i > iold )) ; then
                                newcontainer=$container
                                sudo docker exec $newcontainer pip3 install pycav
                                sudo docker exec $newcontainer pip3 install vpython
                                sudo docker exec $newcontainer pip install pycav
                                sudo docker exec $newcontainer pip install vpython
                                echo $newcontainer
                        fi
        done
done
