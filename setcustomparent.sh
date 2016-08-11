#!/bin/bash
#set custom parent directory

cd "${0%/*}"
cd ..
path=`pwd`
sudo sed -i -- 's/\/home\/public/'$path'/g' ./jupyterhub_config.py
cd server
sudo sed -i -- 's/\/home\/public/'$path'/g' ./startserver.sh
sudo sed -i -- 's/\/home\/public/'$path'/g' ./updatescripts.sh
sudo sed -i -- 's/\/home\/public/'$path'/g' ./updatescripts_subscript.sh
