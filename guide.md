<script type="text/javascript" async
	src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>
$$\rho \gamma c \alpha \nu$$
# **Server Setup Guide**

## **Requirements**
1. Server with a fresh copy of Ubuntu 16.04 Server installed [Download here](http://www.ubuntu.com/download/server).

2. Root access to your server.

3. Internet access on server with all ports open.

4. Static ip on server.

4. Domain name that points to your server's static ip address.

5. A computer that you can use to ssh into your server.

### **Preliminary setup**
1. If your computer is running windows please download putty.exe and puttygen.exe [from here](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)
   if however you are running Linux, or Mac OS then you can ssh into your server from the terminal.
2. On Mac and Linux SSH into your server by running the command ssh root@[ip] in your terminal, replacing [ip] with your
	servers ip address. On Windows you can carry out the same process using the putty gui.
3. Your ssh client will then prompt you to input the server's root password, input the root users password to gain access to your server.
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

7. You will then be prompted for various things relating to the new user, follow these on screen instructions.

8. We must then give this user sudo access which stands for super user do, which allows ths new user to execute commands as the root user.
   We can do this by running

   ```bash 
   usermod -aG sudo [username]
   ```

   where [username] is replaced by the name of the user that you created earlier.

9. To aid security we will now prevent unauthorized computers from logging in to your server. To do this we must create an ssh key on your local machine.
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

10. Switch back to your ssh client and input the following two commands to create and set permissions for the folder containing the authorised keys.
	
	```bash
	runuser -l  [username] -c 'mkdir /home/[username]/.ssh'
	runuser -l [username] -c 'chmod 700 /home/[username]/.ssh'
	```

	Making sure to replace [username] with the name of the user that you created earlier.

11. We will now authorise our computer so that it can access the server using the generated key, run the command below in your ssh client making sure 
	to replace [public-key] and [username] with the key that was generated and the name of the user you created respectively.
	
	```bash
	echo [public-key] > /home/[username]/.ssh/authorized_keys
	runuser -l  [username] -c 'chmod 600 /home/[username]/.ssh/authorized_keys'
	```

12. Make sure you can log in using your public key before running the following commands as they may prevent access to the server if you haven't set
	 up your public-key correctly. If you can log in then run the commands below to remove the ability to log in using passwords (only machines that 
	 have authorised public-keys will be able to log in) and to also remove the ability for people to log in as root to your server remotely. These steps
	 will help to prevent unauthorised users from accessing your server.

	 ```bash
	 sed -i -- 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
	 sed -i -- 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
	 systemctl reload sshd
	 ```

13. This next step will enable a basic firewall for your server and allow ssh connections to pass through it.
	Run the following commands to set this up

	```bash 
	ufw allow OpenSSH
	ufw enable
	ufw status
	```

14. We will now install the rest of the LAMP software stack which includes Linux, Apache, MySQL and PHP. You already have Linux installed on your server, so we will now
install the http server software **Apache** and allow incoming connections to apache to pass through your firewall

	```bash
	apt-get -y install apache2
	ufw allow in "Apache Full"
	```

	we will now install the database software MySQL, on screen prompts will appear after running each of the commands below, make sure to follow the instructions that appear on screen
	
	```bash
	apt-get -y install mysql-server
	mysql_secure_installation
	```

	now to install the final component a scripting language PHP, run the following command to install

	```bash
	apt-get -y install php libapache2-mod-php php-mcrypt php-mysql
	```
