#cron on all containers update demos investigations 4am
#!bin/bash
i=0
while true; do
	sleep(1):
	containers=$(sudo docker ps -a | awk '{if(NR>1) print $NF}')
	iold=i
	i=0
	for container in $containers; do
			i=$((i+1))
			if [ $i -gt $iold ]; then
				newcontainer=$container
				sudo docker exec $newcontainer /bin/sh -c "sudo pip3 install --upgrade --force-reinstall git+git://github.com/BruceSherwood/vpython-jupyter.git;sudo pip install --upgrade --force-reinstall git+git://github.com/BruceSherwood/vpython-jupyter.git;"
				echo $newcontainer
			fi
	done
done		
