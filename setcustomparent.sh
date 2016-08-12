#!/bin/bash
#set custom parent directory


cd "${0%/*}"
cd ..
path=`pwd`
sudo sed -i -- 's:/home/public:'$path':g' ./server/jupyterhub_config.py
sudo sed -i -- 's:/home/public:'$path':g' ./server/startserver.sh
sudo sed -i -- 's:/home/public:'$path':g' ./server/updatescripts.sh
sudo sed -i -- 's:/home/public:'$path':g' ./server/updatescripts_subscript.sh

sudo sed -i -- 's:/home/public:'$path':g' ./server/cron/backup.sh
sudo sed -i -- 's:/home/public:'$path':g' ./server/cron/indexgen.sh
sudo sed -i -- 's:/home/public:'$path':g' ./server/cron/updatenotebooks.sh
