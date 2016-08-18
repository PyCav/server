import os,sys
default_backup="/media/backup/"

path_script=str(os.path.dirname(os.path.realpath(sys.argv[0])))

parent_path=path_script[0:path_script.find("server")]
cron_path=path_script[0:path_script.find("python")]+"cron/"
pathvar='path="'
with open(parent_path+".backup.sh") as f:
	content=f.readlines()
for index,line in enumerate(content):
	if line.find(pathvar) != -1:
		line_num=index
		break

backup_path=content[line_num].strip()[len(pathvar):-1]

with open(cron_path+"backup.sh") as f:
	content=f.readlines()

for index,line in enumerate(content):
	if line.find(default_backup) != -1:
		content[index]='path="'+backup_path+'"\n'

backup_file=open(cron_path+"backup.sh",'w')
for i in range(0, len(content)):
	backup_file.write(content[i])

backup_file.close()
