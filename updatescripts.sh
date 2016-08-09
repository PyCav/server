#!/bin/bash
cd /home/public/server
sudo git pull origin master
#replace domain with site_name and PORT with port
echo "Script assumes you are using raven authentication do you wish to proceed (n)?"
read ans
if [ "$ans" == "y" ]; then
	site_name='domain'
	port='PORT'
	sudo sed -i -- 's/raven = False/raven = True/g' /home/public/server/jupyterhub_config.py
	sudo sed -i -- 's/website/'$site_name'/g' /home/public/server/jupyterhub_config.py
	sudo sed -i -- 's/8000/'$port'/g' /home/public/server/jupyterhub_config.py
	sudo sed -i -- 's/auth_key='\'\''/auth_key='\'$CONFIGPROXY_AUTH_TOKEN\''/g' /home/public/server/jupyterhub_config.py
	sudo sed -i -- 's/#demos_//g' /home/public/server/jupyterhub_config.py
	sudo updatescripts_subscript $site_name $port
	sudo cp updatescripts_subscript.sh /usr/local/bin/updatescripts_subscript
	sudo cp updatescripts.sh /usr/local/bin/updatescripts
fi
cd ~
source .bashrc
echo "Script Complete"