#!/bin/bash
#install ubuntu 16.04 server http://www.ubuntu.com/download/server

#general server set up followed by custom deployment of jupyterhub using fresh ubuntu 16.04 install with root user
sudo apt-get update
sudo apt-get -y upgrade
echo "change root user password:"
passwd root

echo "input username:"
#implement checks?
read user
adduser $user
usermod -aG sudo $user
runuser -l  $user -c 'mkdir ~/.ssh'
runuser -l $user -c 'chmod 700 ~/.ssh'

mkdir /home/public
chmod a+rxw -R /home/public


echo "insert key in file id_rsa.pub generated by local machine after using ssh-keygen (be very careful)"
#implement checks?
read input_variable
echo $input_variable > /home/$user/.ssh/authorized_keys
runuser -l  $user -c 'chmod 600 /home/$user/.ssh/authorized_keys'

sudo ufw allow OpenSSH
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

echo "change PasswordAuthentication to no and allowRootLogin to no"
sleep 2
sudo sed -i -- 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo sed -i -- 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo systemctl reload sshd

sudo ufw enable
#can block access to server
sudo ufw status
sleep 2


#Apache Set Up and testing ip
sudo apt-get -y install apache2
sudo ufw allow in "Apache Full"
echo "Pinging your new webserver"
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

#must have domain set up use domainName.domain to set up
cd /home/public
sudo apt-get -y install python-letsencrypt-apache
echo "enter site name (domainName.domain):"
#implement checks?
read site_name
sudo letsencrypt --apache -d $site_name
export EDITOR=/bin/nano


#set up crons
crontab -l > mycron
echo "07 04 * * * letsencrypt renew" >> mycron
crontab mycron
rm mycron

#change AllowOverride None to AllowOverride FileInfo in /etc/apache2/apache2.conf for /var/www/
#needs fixing?
#sudo sed -i -- 's/<Directory /var/www/>'$'\n'$'\t''Options Indexes FollowSymLinks'$'\n'$'\t''AllowOverride None/<Directory /var/www/>'$'\n'$'\t''Options Indexes FollowSymLinks'$'\n'$'\t''AllowOverride FileInfo/g' /etc/apache2/apache2.conf
sudo sed -i -- 's/AllowOverride None/AllowOverride FileInfo/g' /etc/apache2/apache2.conf
#enable virtual hosts?
#enable virtual hosts?
ipformatted=$(echo "$ip" | sed -s 's/[.]/''\\.''/g')
sudo echo "RewriteCond %{HTTP_HOST} ^""$ipformatted" >> /var/www/html/.htaccess
sudo echo "RewriteRule (.*) https://""$site_name""/$1 [R=301,L]" >> /var/www/html/.htaccess
#to enable .htaccess
sudo a2enmod rewrite 
sudo systemctl restart apache2
sudo systemctl status apache2
sleep 2

#set up internal
sudo apt-get -y install git
sudo apt-get -y install python3-pip python-pip
sudo pip3 install --upgrade pip
sudo pip install --upgrade pip

#setup dependencies
sudo apt-get -y install npm nodejs nodejs-legacy libjs-mathjax
#sudo apt-get install python3-flask

#Here begins the custom deployment
sudo apt-get -y install docker.io
sudo npm install -g configurable-http-proxy
sudo pip3 install --upgrade jupyterhub  
sudo pip3 install --upgrade notebook 
sudo pip3 install --upgrade oauthenticator

sudo pip3 install --upgrade dockerspawner netifaces
#sudo docker pull jupyterhub/singleuser

sudo pip3 install --upgrade nbgrader



#allow ports that you wish jupyterhub and binder to run on.
echo 'port to run jupyterhub on (not 443 or 80) default 8000:'
#do a check
read port
sudo ufw allow $port
sudo ufw allow 8081
cd /home/public/
wget https://raven.cam.ac.uk/project/apache/files/Debs/libapache2-mod-ucam-webauth_2.0.3apache24~ubuntu_amd64.deb
sudo dpkg -i libapache2-mod-ucam-webauth_2.0.3apache24~ubuntu_amd64.deb
sudo rm libapache2-mod-ucam-webauth_2.0.3apache24~ubuntu_amd64.deb


#to password protect whole site implement

#http://www-h.eng.cam.ac.uk/help/tpl/network/pin_control.html set up in root dir /etc/apache2/apache2.conf
#openssl rand -base64 32 generate cookie key
#public keys raven https://raven.cam.ac.uk/project/keys/ in /etc/apache2/conf/webauth_keys


cd /home/public/
git clone https://github.com/pycav/server.git
cd /home/public/server/webpages
sudo sed -i -- 's/8000/'$port'/g' /home/public/server/webpages/index.php
sudo mv * /var/www/html/
sudo service apache2 restart
cd /home/public
chmod a+x /home/public/server/*.sh

cd /home/public/server
sudo docker build -t jupyterhub/customsingleuser .

git clone https://github.com/PyCav/jupyterhub-raven-auth.git
#cron job to update docker container's software or upload to pypi?
sudo pip3 install --upgrade jupyterhub-raven-auth/
sudo rm -R jupyterhub-raven-auth/ 

sudo sed -i -- 's/pycav.ovh/'$site_name'/g' /home/public/server/jupyterhub_config.py
sudo sed -i -- 's/8000/'$port'/g' /home/public/server/jupyterhub_config.py
sudo sed -i -- 's/auth_key='\'\''/auth_key='\'$(openssl rand -base64 32)\''/g' /home/public/server/jupyterhub_config.py
#may need to be run twice? sudo sed -i -- 's/auth_key='\'\''/auth_key='\'$(openssl rand -base64 32)\''/g' /home/$user/Server/jupyterhub_config.py

#set up publicly viewable and executable hard disk with pycav demos docker virtual disks cron job update
cd /home/public
git clone https://github.com/pycav/demos.git

crontab -l > mycron
echo "10 04 * * * rm -R /home/public/demos && git clone https://github.com/pycav/demos.git /home/public" >> mycron
crontab mycron
rm mycron

#set up nbgrader?
#server across nodes docker.com?
#customise jupyterhub?
#create persistant userdata docker volumes so containers can be updated as necessary

#add startserver.sh to path

sudo cp /home/public/server/startserver.sh /usr/local/bin/startServer
source .bashrc

#so user can edit website without sudo? also part of general set up?
#chgrp $user -R /var/www/html
echo "login as ""$user"" now."

echo "to run server in background: screen; sudo startServer; ctrl-a; ctrl-d;"
su $user
#in server folder  webpages/ startserver.sh, killidlecontainers.sh,updatecontainers.sh setupcontainers.sh, jupyterhub_config.py
#setupContainers with vpython and pycav library demos and investigations repos setup admin accounts from whitelist
#jupyterhub customisation custom logos and jupyter extensions
#cull idle docker containers

