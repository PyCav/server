#!/bin/bash
#install ubuntu 16.04 server http://www.ubuntu.com/download/server

sudo apt-get update
sudo apt-get -y upgrade
echo "input username:"
read user
adduser $user
usermod -aG sudo $user
runuser -l  $user -c 'mkdir ~/.ssh'
runuser -l $user -c 'chmod 700 ~/.ssh'
#mkdir /home/$user/.ssh
#chmod 700 /home/$user/.ssh

echo "insert key in file id_rsa.pub generated by local machine after using ssh-keygen (be very careful)"
read input_variable
echo $input_variable >> /home/$user/.ssh/authorized_keys
#is an option
#echo 'insert key here ' > ~/.ssh/authorized_keys
runuser -l  $user -c 'chmod 600 /home/$user/.ssh/authorized_keys'
echo "change PasswordAuthentication to no and allowRootLogin to no"
sleep 2
sudo sed -i -- 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo sed -i -- 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

sudo systemctl reload sshd
sudo ufw allow OpenSSH
#enclose in if canLogin check
sudo ufw enable
#can blovk access to server
sudo ufw status
sleep 2


#Apache Set Up and testing ip
sudo apt-get -y install apache2
sudo ufw allow in "Apache Full"
ip=$(curl http://icanhazip.com)
ping -c 3 $ip

#MySQL Set Up
sleep 2
sudo apt-get -y install mysql-server
echo "follow steps below"
sleep 2
sudo mysql_secure_installation

#PHP Set Up
sudo apt-get -y install php libapache2-mod-php php-mcrypt php-mysql
echo "Move index.php to just after DirectoryIndex"
sleep 2
sudo sed -i -- 's/index.php/k.html/g' /etc/apache2/mods-enabled/dir.conf
sudo sed -i -- 's/index.html/index.php/g' /etc/apache2/mods-enabled/dir.conf
sudo sed -i -- 's/k.html/index.html/g' /etc/apache2/mods-enabled/dir.conf


#set up virtual hosts https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-16-04

#can be ignored
sudo echo $'<?php\necho \'Hello World\';' > /var/www/html/index.php
sudo echo $'?>' >> /var/www/html/index.php
#change AllowOverride None to AllowOverride FileInfo in /etc/apache2/apache2.conf for /var/www/
#enable virtual hosts sudo echo "RewriteCond %{HTTP_HOST} ^ip\.goes\.in\.here" >> /var/www/html/.htaccess
#sudo echo RewriteRule (.*) https://domainName.domain/$1 [R=301,L] >> /var/www/html/.htaccess
#sudo a2enmod rewrite #to enable .htaccess
sudo systemctl restart apache2
sudo systemctl status apache2
sleep 2

#set up internal
sudo apt-get -y install git
sudo apt-get -y install python3-pip python-pip
sudo pip3 install --upgrade pip
sudo pip install --upgrade pip

#must have domain set up use domainName.domain to set up
cd /home/$user
sudo apt-get -y install python-letsencrypt-apache
echo "enter site name (domainName.domain):"
read site_name
sudo letsencrypt --apache -d $site_name
export EDITOR=/bin/nano

crontab -l > mycron
echo "07 04 * * * letsencrypt renew" >> mycron
crontab mycron
rm mycron

#setup dependencies
sudo apt-get -y install npm nodejs nodejs-legacy
#sudo apt-get install python3-flask

sudo apt-get -y install docker.io
sudo npm install -g configurable-http-proxy
sudo pip3 install jupyterhub  
sudo pip3 install --upgrade notebook 
sudo pip3 install oauthenticator

sudo pip3 install dockerspawner netifaces
sudo docker pull jupyterhub/singleuser
sudo pip3 install nbgrader

#Install binder code for demos needs virtual hosts
#
#
#
#

#allow ports that you wish jupyterhub and binder to run on. input ports?
sudo ufw allow 8000
sudo ufw allow 8081
cd /home/$user/
wget https://raven.cam.ac.uk/project/apache/files/Debs/libapache2-mod-ucam-webauth_2.0.3apache24~ubuntu_amd64.deb
sudo dpkg -i libapache2-mod-ucam-webauth_2.0.3apache24~ubuntu_amd64.deb
sudo rm libapache2-mod-ucam-webauth_2.0.3apache24~ubuntu_amd64.deb


#to password protect whole site implement

#http://www-h.eng.cam.ac.uk/help/tpl/network/pin_control.html set up in root dir /etc/apache2/apache2.conf
#openssl rand -base64 32 generate cookie key
#public keys raven https://raven.cam.ac.uk/project/keys/ in /etc/apache2/conf/webauth_keys


cd /home/$user
git clone https://github.com/pycav/server.git
cd /home/$user/Server/webpages
sudo mv * /var/www/html/
sudo service apache2 restart
cd /home/$user/Server 
sudo sed -i -- 's/pycav.ovh/'$site_name'/g' /home/$user/Server/jupyterhub_config.py
sudo sed -i -- 's/auth_key='\'\''/auth_key='\'$(openssl rand -base64 32)\''/g' /home/$user/Server/jupyterhub_config.py
chmod u+x *.sh
cd /home/$user
git clone https://github.com/PyCav/jupyterhub-raven-auth.git
#cron job to update docker container's software or upload to pypi
sudo pip3 install jupyterhub-raven-auth/
sudo rm -R jupyterhub-raven-auth/ 

#alter jupyterhub_config.py to use site_name instead of pycav.ovh

echo "to run server in background screen sudo /home/jordan/server/startServer.sh ctrl-a ctrl-d"
#in server folder  webpages/ startserver.sh, cleanupcontainers.sh, setupcontainers.sh, admin.sh, jupyterhub_config.py
#setupContainers with vpython and pycav library demos and investigations repos setup admin accounts from whitelist
#jupyterhub customisation custom logos and jupyter extensions
#cull idle docker containers

