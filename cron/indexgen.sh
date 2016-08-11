#!/bin/bash
cd "${0%/*}"
cd ../python/
python3 ./index_generator.py -p /home/public/demos -t "PyCav Demos Index"
python3 ./index_generator.py -p /home/public/data -t "PyCav Data Notebooks"
python3 ./index_generator.py -p /home/public/investigations -t "PyCav Investigations Notebooks"