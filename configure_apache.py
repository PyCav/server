try:
	foundLine=False
	with open("/etc/apache2/apache2.conf",'r') as f:
		contents = f.readlines()
	
	for i in range(0,len(contents)):
		if contents[i].find("<Directory /var/www/>") != -1 :
			foundLine=True
		if foundLine:
			if contents[i].find("AllowOverride None") != -1:
				contents[i]="\tAllowOverride FileInfo\n"
				break

	apacheConf=open("/etc/apache2/apache2.conf",'w')	
	for line in contents:
		apacheConf.write(line)
	apacheConf.close()

	print("Apache config file successfully edited.")

except Exception as e:
	print("Couldn't edit Apache config file.'")
	print("Error type: ",type(e))
