#!/bin/bash
./rmall.sh
docker rmi jupyter/custom
docker rmi jupyter/configurable-http-proxy
docker rmi jupyter/minimal-notebook
docker pull jupyter/minimal-notebook
docker pull jupyter/configurable-http-proxy
docker build -t jupyter/custom:latest .
export TOKEN=$( head -c 30 /dev/urandom | xxd -p )
docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN \
	--name=proxy jupyter/configurable-http-proxy --default-target http://127.0.0.1:9999 #\
	#--ssl-key=/etc/letsencrypt/live/evolve.ovh/privkey.pem --ssl-cert=/etc/letsencrypt/live/evolve.ovh/fullchain.pem
docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN \
	-v /var/run/docker.sock:/docker.sock \
	jupyter/tmpnb python orchestrate.py --image='jupyter/custom' \
	--command="jupyter notebook --NotebookApp.base_url={base_path} --port {port}  --ip=*" #\
        #--no-browser --NotebookApp.allow_origin=* --cull-timeout=300 --cull_period=60"