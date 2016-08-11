#!/bin/bash
cd "${0%/*}"
#add to roots cron ?
rm -R /home/public/demos
rm -R /home/public/data
rm -R /home/public/investigations
git clone https://github.com/pycav/demos.git /home/public/demos
git clone https://github.com/pycav/data.git /home/public/data
git clone https://github.com/pycav/investigations.git /home/public/investigations
./indexgen.sh
