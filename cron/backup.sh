#!/bin/bash
#cron this script for a backup?
#mount remote directory for backup? 
filenameMod=$(date "+%Y_%m_%d")
path="/media/backup/users_backup_""$filenameMod"".tar.gz"
tar -zcvf $path /home/public/users/

#tar -zxvf archive.tar.gz to decompress archive