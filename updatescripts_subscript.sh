#!/bin/bash
cd /home/public/server
sudo sed -i -- 's/domain/'$1'/g' ./updatescripts.sh
sudo sed -i -- 's/PORT/'$2'/g' ./updatescripts.sh
