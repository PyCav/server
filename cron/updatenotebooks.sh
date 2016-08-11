#!/bin/bash

#add to roots cron ?
rm -R /home/public/demos
rm -R /home/public/data
rm -R /home/public/investigations
git clone https://github.com/pycav/demos.git /home/public/demos
git clone https://github.com/pycav/data.git /home/public/data
git clone https://github.com/pycav/investigations.git /home/public/investigations
cd /home/public/server/python/
python3 index_generator.py -p /home/public/demos -t "PyCav Demos Index"
python3 index_generator.py -p /home/public/data -t "PyCav Data Notebooks"
python3 index_generator.py -p /home/public/investigations -t "PyCav Investigations Notebooks"