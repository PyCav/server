#cron this once a week?
#!bin/bash

#must delete containers and reinit need persistant data volumes
for container in $containers; do
		i=$((i+1))
		if [ $i -gt $iold ]; then
			newcontainer=$container
			sudo docker exec $newcontainer
		fi
done

