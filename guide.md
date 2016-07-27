<script type="text/javascript" async
	src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>
<!--  SELinux nano /etc/selinux/config  edit sudo apt-get install policycoreutils selinux reboot touch /.autorelabel -->
<p align="center">
<img src="pycav_latex.png"></img>
</p>

# **JupyterHub Server Setup Guide**
#### *Using Docker Containers, Authentication Services and NbGrader*

## **Requirements**
1. Server with a fresh copy of Ubuntu 16.04 Server installed [Download here](http://www.ubuntu.com/download/server).

2. Root access to your server.

3. Internet access on server with all ports open.

4. Static ip on server.

4. Domain name that points to your server's static ip address, with url forwarding such that www.domainname redirects to domainname

5. A computer that you can use to ssh into your server.

### **Preliminary setup**
1. If your computer is running windows please download putty.exe and puttygen.exe [from here](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)
	if however you are running Linux, or Mac OS then you can ssh into your server from the terminal.

2. On Mac and Linux SSH into your server by running the command ssh root@[ip] in your terminal, replacing [ip] with your
	servers ip address. On Windows you can carry out the same process using the putty gui.

3. Your ssh client will then prompt you to input the server's root password, input the root users password to 
	gain access to your server.

4. It is good practice to change the root users password to something more secure, you can do this by running the command
	
	```shell 
	passwd
	```

	and following the on screen insturctions.

5. Now update your software sources and software packages to their latest version by running
	
	```bash 
	apt-get -y update && apt-get -y upgrade
	```

	in your ssh client.

6. We shall now create a new user on the server as running everything as root is generally a bad idea we can do this by typing   

	```bash 
	adduser [username]
	```

	into your client and replacing [username] with the name of the user you wish to create.
	You will then be prompted for various things relating to the new user, follow these on screen instructions.
7. We must then give this user sudo access which stands for super user do, which allows ths new user to execute commands as the root user.
   We can do this by running
   
   ```bash 
   usermod -aG sudo [username]
   ```

   where [username] is replaced by the name of the user that you just created.

8. To aid security we will now prevent unauthorized computers from logging in to your server. To do this we must create an ssh key on your local machine.
   To do this on Mac or Linux open a local terminal and run the command
   
   ```bash
   ssh-keygen
   ```

   and save in the default location. To view the generated key type in the same local terminal the command
   
   ```bash 
   cat ~/.ssh/id_rsa.pub
   ```

   To do this on Windows open the file named puttygen.exe that was downloaded earlier and use that to generate and view your machine's ssh key.
   **Note this key down somewhere that is easily accessible.**

9. Switch back to your ssh client and input the following two commands to create and set permissions for the folder containing the authorised keys.
	
	```bash
	runuser -l  [username] -c 'mkdir /home/[username]/.ssh'
	runuser -l [username] -c 'chmod 700 /home/[username]/.ssh'
	```

	Making sure to replace [username] with the name of the user that you created earlier.

10. We will now authorise our computer so that it can access the server using the generated key, run the command below in your ssh client making sure 
	to replace [public-key] and [username] with the key that was generated and the name of the user you created respectively.
	
	```bash
	echo [public-key] > /home/[username]/.ssh/authorized_keys
	runuser -l  [username] -c 'chmod 600 /home/[username]/.ssh/authorized_keys'
	```

11. Make sure you can log in using your public key before running the following commands as they may prevent access to the server if you haven't set
	 up your public-key correctly. If you can log in then run the commands below to remove the ability to log in using passwords (only machines that 
	 have authorised public-keys will be able to log in) and to also remove the ability for people to log in as root to your server remotely. These steps
	 will help to prevent unauthorised users from accessing your server.
	 
	 ```bash
	 sed -i -- 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
	 sed -i -- 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
	 systemctl reload sshd
	 ```

12. This next step will enable a basic firewall for your server and allow ssh connections to pass through it.
	Run the following commands to set this up
	
	```bash 
	ufw allow OpenSSH
	ufw enable
	ufw status
	```

13. We will now install the rest of the LAMP software stack which includes Linux, Apache, MySQL and PHP. You already have **Linux** installed on your server, so we will now
	install the http server software **Apache** and allow incoming connections to apache to pass through your firewall
	
	```bash
	apt-get -y install apache2
	ufw allow in "Apache Full"
	```

	You can print the status of Apache by running the command (although it doesn't need to be run to proceed)

	```bash 
	systemctl status apache2
	```

	we will now install the database software **MySQL**, on screen prompts will appear after running each of the commands below, make sure to follow the instructions that appear on screen
	
	```bash
	apt-get -y install mysql-server
	mysql_secure_installation
	```

	now to install the final component, a scripting language **PHP**, run the following command
	
	```bash
	apt-get -y install php libapache2-mod-php php-mcrypt php-mysql
	```

14. The next three commands will reorder the priority of files that apache uses as your server's homepage,
	by default index.html in the folder /var/www/html/ is the default landing page, these commands will change it so
	that index.php (same directory) is the default homepage.
	
	```bash
	sed -i -- 's/index.php/temp.html/g' /etc/apache2/mods-enabled/dir.conf
	sed -i -- 's/index.html/index.php/g' /etc/apache2/mods-enabled/dir.conf
	sed -i -- 's/temp.html/index.html/g' /etc/apache2/mods-enabled/dir.conf
	```

15. The command below will now create a sample homepage written in php that prints the words Hello World!
	
	```bash
	echo $'<?php\necho \'Hello World!\';?>' > /var/www/html/index.php
	```

	Test this out by directing your browser to your domain name. You should see a white page with the words Hello World! on it.

16. We will now configure https access to our server by generating our own certificates using the letsencrypt software package, first we must install letsencrypt

	```bash
	apt-get -y install python-letsencrypt-apache
	```

	Now run the following command making sure to replace [domain] with the domain name (in the format example.com) that points to your server's ip address

	```bash
	letsencrypt --apache -d [domain]
	```

	after inputting this command a prompt will appear, follow the on screen instructions and select secure (to permit https access only) when prompted.

	The certificates this software generates are only valid for 90 days before we need to renew them luckily we can set this up to happen automatically using a cronjob.
	To set up a cron job to try to renew our certificate at 4am every everyday we can run the following commands

	```bash
	crontab -l > mycron
	echo "00 04 * * * letsencrypt renew" >> mycron
	crontab mycron
	rm mycron
	```

	The commands above create a cron job that runs letsencrypt renew at 00 minutes, 04 hours, every day, every month and every day of the week.

17. The following commands will prevent users from accessing your server via its IP address and force them to access your site through https at your domain.
	First we need to download a python script that will alter the apache config file so that redirects are allowed. Before this though we will back up a working copy of the config file.

	```bash
	cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.working
	curl https://raw.githubusercontent.com/PyCav/Server/master/configure_apache.py
	python3 configure_apache.py
	rm configure_apache.py
	```

	Now we need to format your server's public IP address so that it is laid out how apache expects, we can use the website http://icanhazip.com to determine your server's IP address. Run the following 
	commands to do this making sure you replace [domain] with your server's domain name (in the format example.com) in the final command.

	```bash
	ipformatted=$(echo "$(curl http://icanhazip.com)" | sed -s 's/[.]/''\\.''/g')
	echo "RewriteCond %{HTTP_HOST} ^""$ipformatted" >> /var/www/html/.htaccess
	rm ipformatted
	echo "RewriteRule (.*) https://""[domain""/$1 [R=301,L]" >> /var/www/html/.htaccess
	```

	We now need to restart apache for these changes to take effect. To do this run

	```bash
	a2enmod rewrite
	systemctl restart apache2
	```
18. Now on to the final part of preliminary setup, installing useful libraries.
	We need to install git so that we can clone git repos, to do this run the command

	```bash
	apt-get -y install git
	```

	We can also install the program htop which is a useful tool for managing running processes on your server, to install run the command

	```bash
	apt-get install htop
	```

	Another useful piece of software is the python tool pip, which allows you to install python libraries and all their dependencies very easily using commands such as "pip3 install numpy". To set up pip for both
	python2 and python3 you need to run the next 3 commands

	```bash
	apt-get -y install python3-pip python-pip
	pip3 install --upgrade pip
	pip install --upgrade pip
	```

	Finally we can install many useful javascript libraries using the command below

	```bash
	apt-get -y install npm nodejs nodejs-legacy libjs-mathjax
	```

### **Jupyterhub and Docker**
In this next section we shall set up a Jupyterhub Server that isolates users using docker containers.

### **Authentication**
In this section we will describe how to set up a variety of authentication methods (Raven, Github, Local User) which prevent unauthorised users from accessing your JupyterHub server.
#### **Raven**

#### **Github**

#### **Local User**

### **NbGrader**
This section will discuss how to set up NbGrader up on your server, so that you can create assignments for users to complete and hand in. It will also show you how to set up NbGrader so that assignments are automatically marked.

### **JupyterHub Config File**

### **Running The Server**
In this final section you will find out about the various scripts that come from the PyCav project which will help to maintain your server. You will also find out how to start your server.