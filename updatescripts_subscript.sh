#!/bin/bash

sudo sed -i -- 's/domain/'$1'/g' /home/public/server/updatescripts.sh
sudo sed -i -- 's/PORT/'$2'/g' /home/public/server/updatescripts.sh