#!/bin/bash
#cron this script for a backup
filenameMod=$(date "+%Y_%m_%d")
path="/media/backup/"
pathmod=$path"users_backup_"$filenameMod".tar.gz"
tar -zcvf $pathmod /home/public/users/
#tar -zxvf archive.tar.gz to decompress archive
