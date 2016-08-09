#!/bin/bash
cd /home/public/server
#replace domain with site_name and PORT with port
echo "Script assumes you are using raven authentication."
echo "Script will also overwrite any changes you have made to files in your server directory."
sleep 2
echo "Do you still wish to proceed (n)?"
read ans
if [ "$ans" == "y" ]; then
	sudo git pull origin master
	site_name='domain'
	port='PORT'
	#raven r , github g, local user l flags?
	sudo sed -i -- 's/raven = False/raven = True/g' /home/public/server/jupyterhub_config.py
	sudo sed -i -- 's/website/'$site_name'/g' /home/public/server/jupyterhub_config.py
	sudo sed -i -- 's/8000/'$port'/g' /home/public/server/jupyterhub_config.py
	sudo sed -i -- 's/auth_key='\'\''/auth_key='\'$CONFIGPROXY_AUTH_TOKEN\''/g' /home/public/server/jupyterhub_config.py
	sudo sed -i -- 's/#demos_//g' /home/public/server/jupyterhub_config.py
	sudo updatescripts_subscript $site_name $port
	sudo chmod a+x *.sh
	sudo cp ./updatescripts_subscript.sh /usr/local/bin/updatescripts_subscript
	sudo cp ./updatescripts.sh /usr/local/bin/updatescripts
	sudo cp /home/public/server/startserver.sh /usr/local/bin/startserver
	sudo cp /home/public/server/killserver.sh /usr/local/bin/killserver
	sudo cp /home/public/server/removecontainers.sh /usr/local/bin/removecontainers
	sudo cp /home/public/server/updatecontainers.sh /usr/local/bin/updatecontainers
fi
cd ~
source .bashrc
echo "Script Complete"
