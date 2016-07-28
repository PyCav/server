#!/bin/bash
#install ubuntu 16.04 server http://www.ubuntu.com/download/server

#general server set up followed by custom deployment of jupyterhub using fresh ubuntu 16.04 install with root user
echo "Output from script saved in working directory as server.log"
echo "Updating software sources"
sudo dpkg --configure -a
sudo apt-get update >> server.log
echo "Upgrading server software"
sudo apt-get -y upgrade >> server.log
echo "Upgraded server software"

echo "Setting up System Users"
echo "Change root user password:"
passwd root
echo "Root password changed"

echo "Input username of main user:"
#implement checks?
read user
adduser $user
usermod -aG sudo $user
runuser -l  $user -c 'mkdir ~/.ssh'
runuser -l $user -c 'chmod 700 ~/.ssh'
echo "Created user "$user""

echo "Setting up SSH"
echo "Insert key in file id_rsa.pub generated by local machine after using ssh-keygen (be very careful)"
read input_variable
echo $input_variable > /home/$user/.ssh/authorized_keys
runuser -l  $user -c 'chmod 600 /home/$user/.ssh/authorized_keys'
sudo ufw allow OpenSSH >> server.log
echo "Test if you can login as new user using public key authentication"
while : ; do
  echo "can you login (y/n)"
  read answer
  if [ "$answer" == "y" ]; then
      break
  fi
  echo "insert key in file id_rsa.pub generated by local machine after using ssh-keygen (be very careful)"
  read input_variable
  echo $input_variable > /home/$user/.ssh/authorized_keys
done
echo "SSH login by key is now available"

echo "Securing SSH access by setting PasswordAuthentication to no and allowRootLogin to no"
sudo sed -i -- 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo sed -i -- 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo systemctl reload sshd
echo "Secured"

echo "Enabling firewall"
sudo ufw enable
sudo ufw status >> server.log

echo "Installing Apache"
sudo apt-get -y install apache2 >> server.log
sudo ufw allow in "Apache Full"
echo "Pinging your new webserver"
ip=$(curl http://icanhazip.com)
ping -c 3 $ip
echo "Installed Apache"

echo "Installing MySQL"
sudo apt-get -y install mysql-server
echo "Follow MySQL secure Installation set up instructions below"
sleep 1
sudo mysql_secure_installation
echo "Installed MySQL"

echo "Installing PHP"
sudo apt-get -y install php libapache2-mod-php php-mcrypt php-mysql >> server.log
echo "Installed PHP"

echo "Making index.php the default homepage of the server"
sudo sed -i -- 's/index.php/k.html/g' /etc/apache2/mods-enabled/dir.conf
sudo sed -i -- 's/index.html/index.php/g' /etc/apache2/mods-enabled/dir.conf
sudo sed -i -- 's/k.html/index.html/g' /etc/apache2/mods-enabled/dir.conf


#set up virtual hosts https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-16-04

echo "Creating a sample index.php file"
sudo echo $'<?php\necho \'Hello World!\';?>' > /var/www/html/index.php

#must have domain set up use domainName.domain with url forwarding of www.domainName.domain to domainName.domain
echo "Setting up HTTPS access for server"
cd /home/public
sudo apt-get -y install python-letsencrypt-apache >> server.log
echo "Enter site name (domainName.domain):"
#implement checks?
read site_name
echo "Follow the instructions below (select Secure when prompted)"
sudo letsencrypt --apache -d $site_name
export EDITOR=/bin/nano


#set up crons
echo "Setting up automated renewal of SSL certificate"
crontab -e
crontab -l > mycron
echo "07 04 * * * letsencrypt renew" >> mycron
crontab mycron
rm mycron


echo "Preventing access to server by IP address (domain access only)"
cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.working
curl https://raw.githubusercontent.com/PyCav/Server/master/python/configure_apache.py
python3 configure_apache.py
rm configure_apache.py
#enable virtual hosts?
ipformatted=$(echo "$ip" | sed -s 's/[.]/''\\.''/g')
sudo echo "RewriteCond %{HTTP_HOST} ^""$ipformatted" >> /var/www/html/.htaccess
sudo echo "RewriteRule (.*) https://""$site_name""/$1 [R=301,L]" >> /var/www/html/.htaccess
#to enable .htaccess
sudo a2enmod rewrite 
sudo systemctl restart apache2
sudo systemctl status apache2 >> server.log
echo "Access to server by its IP has been prevented"

#enables selinux
#sudo apt-get install policycoreutils
#sudo apt-get install selinux

echo "Installing git, pip, sysstat and htop"
sudo apt-get -y install git >> server.log
echo "Installed git"
sudo apt-get -y install htop >> server.log
echo "Installed htop"
sudo apt-get -y install python3-pip python-pip >> server.log
sudo pip3 install --upgrade pip >> server.log
sudo pip install --upgrade pip >> server.log
echo "Installed pip"
sudo apt-get -y install sysstat >> server.log
echo "Installed sysstat"



#setup dependencies
echo "Installing javascript dependencies"
sudo apt-get -y install npm nodejs nodejs-legacy libjs-mathjax >> server.log
echo "Installed javascript dependencies"

#git clone https://github.com/mathjax/MathJax.git /var/www/html/MathJax

#Here begins the custom deployment change to allow custom authenticators github...
echo "Would you like to install jupyterhub and nbgrader with raven authentication?"
read jup
if [ "$jup" == "y" ]; then
	echo "Creating public directory"
	mkdir /home/public
	mkdir /home/public/users
	chmod a+rxw -R /home/public

	echo "Installing Docker and its dependencies"
	sudo apt-get -y install docker.io >> server.log
	echo "Installed docker.io"
	sudo npm install -g configurable-http-proxy >> server.log
	echo "Installed configurable-http-proxy"
	sudo pip3 install --upgrade jupyterhub >> server.log
	sudo pip3 install --upgrade notebook >> server.log
	sudo pip3 install --upgrade oauthenticator >> server.log
	echo "Installed oauthenticator"
	sudo pip3 install --upgrade dockerspawner netifaces >> server.log
	echo "Installed dockerspawner and netifaces"

	echo "Installing nbgrader"
	sudo pip3 install --upgrade nbgrader >> server.log
	echo "Installed nbgrader"


	echo "Setting up firewall to allow access to jupyterhub"
	echo "Port to run jupyterhub on (not 443 or 80) default 8000:"
	read port
	if [ "$port" == "" ]; then
		port=8000
	fi
	sudo ufw allow $port >> server.log
	sudo ufw allow 8081 >> server.log

	#enclose in if statements if git auth wanted might not be needed?
	echo "Installing ucam-webauth for Raven authentication"
	cd /home/public/
	wget https://raven.cam.ac.uk/project/apache/files/Debs/libapache2-mod-ucam-webauth_2.0.3apache24~ubuntu_amd64.deb >> server.log
	sudo dpkg -i libapache2-mod-ucam-webauth_2.0.3apache24~ubuntu_amd64.deb >> server.log
	sudo rm libapache2-mod-ucam-webauth_2.0.3apache24~ubuntu_amd64.deb
	echo "Installed ucam-webauth"

	#to password protect whole site implement
	#http://www-h.eng.cam.ac.uk/help/tpl/network/pin_control.html set up in root dir /etc/apache2/apache2.conf
	#openssl rand -base64 32 generate cookie key
	#public keys raven https://raven.cam.ac.uk/project/keys/ in /etc/apache2/conf/webauth_keys

	echo "Cloning server files from github"
	cd /home/public/
	git clone https://github.com/pycav/server.git
	cd /home/public/server/webpages
	sudo sed -i -- 's/8000/'$port'/g' /home/public/server/webpages/index.php
	sudo sed -i -- 's/[domain]/'$site_name'/g' /home/public/server/webpages/index.php
	sudo mv * /var/www/html/
	sudo service apache2 restart
	cd /home/public
	chmod a+x /home/public/server/*.sh
	#add to crontab?
	chmod a+x /home/public/server/cron/*.sh
	echo "Succesfully cloned repository"

	echo "Getting docker image for a single user notebook"
	cd /home/public/server
	echo "Do you wish to use a custom dockerfile (no)?"
	read answer
	if [ "$answer" == "y" ]; then
		echo "Where is your dockerfile (path)?"
		read path
		sudo docker -t build docker build -t $user/singleuser:latest $path 
	else
		sudo docker pull jordanosborn/pycav 
	fi
	echo "Docker image downloaded"
	#sudo docker build -t jordanosborn/pycav:latest .
	#https://hub.docker.com/r/jordanosborn/pycav/

	echo "Installing latest jupyterhub-raven-auth from github"
	# upload to pypi?
	pip3 install --upgrade git+git://github.com/PyCav/jupyterhub-raven-auth.git >> server.log
	echo "jupyterhub-raven-auth installed"

	echo "Setting up jupyterhub_config file"
	sudo sed -i -- 's/raven = False/raven = True/g' /home/public/server/jupyterhub_config.py
	sudo sed -i -- 's/[domain]/'$site_name'/g' /home/public/server/jupyterhub_config.py
	sudo sed -i -- 's/8000/'$port'/g' /home/public/server/jupyterhub_config.py
	sudo sed -i -- 's/auth_key='\'\''/auth_key='\'$(openssl rand -base64 32)\''/g' /home/public/server/jupyterhub_config.py
	#may need to be run twice? sudo sed -i -- 's/auth_key='\'\''/auth_key='\'$(openssl rand -base64 32)\''/g' /home/$user/Server/jupyterhub_config.py

	#set up publicly viewable and executable hard disk with pycav demos docker virtual disks cron job update
	echo "Creating a publically readable folder containing the demos from the pycav/demos github repository"
	cd /home/public
	git clone https://github.com/pycav/demos.git >> server.log

	#does this need to be here
	crontab -l > mycron
	echo "10 04 * * * rm -R /home/public/demos" >> mycron 
	echo "12 04 * * * git clone https://github.com/pycav/demos.git /home/public" >> mycron
	crontab mycron
	rm mycron

	#cron job to update docker image?

	#set up nbgrader?
	#server across nodes docker.com?
	#customise jupyterhub?

	#add startserver.sh to path
	sudo cp /home/public/server/startserver.sh /usr/local/bin/startserver
	echo "To run server in background: screen; sudo startServer; ctrl-a; ctrl-d;"
fi
#so user can edit website without sudo? also part of general set up?
#chgrp $user -R /var/www/html
echo "Logging in as ""$user"" "

su $user
#in server folder  webpages/ startserver.sh, killidlecontainers.sh,updatecontainers.sh, jupyterhub_config.py
#setup admin accounts and whitelist?
#jupyterhub customisation custom logos and jupyter extensions
#cull idle docker containers?

