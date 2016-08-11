#!/bin/bash
cd /home/public

#replace domain with site_name and PORT with port
echo "Script assumes you are using raven authentication."
echo "Script will also overwrite any changes you have made to files in your server directory."
sleep 1
echo "Do you still wish to proceed (n)?"
read ans
if [ "$ans" == "y" ]; then
	sudo killserver
	sudo rm -R server
	sudo git clone https://github.com/pycav/server.git
	cd server
	sudo chmod a+x *.sh
	sudo chmod a+x ./cron/*.sh
	site_name='domain'
	port='PORT'
	#raven r , github g, local user l flags?
	sudo sed -i -- 's/raven = False/raven = True/g' ./jupyterhub_config.py
	sudo sed -i -- 's/website/'$site_name'/g' ./jupyterhub_config.py
	sudo sed -i -- 's/8000/'$port'/g' ./jupyterhub_config.py
	sudo sed -i -- 's/auth_key='\'\''/auth_key='\'$CONFIGPROXY_AUTH_TOKEN\''/g' ./jupyterhub_config.py
	sudo sed -i -- 's/#demos_//g' ./jupyterhub_config.py
	sudo updatescripts_subscript $site_name $port
	sudo ./setcustomparent.sh
	sudo cp ./updatescripts_subscript.sh /usr/local/bin/updatescripts_subscript
	sudo cp ./updatescripts.sh /usr/local/bin/updatescripts
	sudo cp ./startserver.sh /usr/local/bin/startserver
	sudo cp ./killserver.sh /usr/local/bin/killserver
	sudo cp ./removecontainers.sh /usr/local/bin/removecontainers
	sudo cp ./updatecontainers.sh /usr/local/bin/updatecontainers
fi

sudo runuser -l $USER -c 'source ~/.bashrc'
echo "Script Complete"

