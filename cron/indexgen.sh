#!/bin/bash
cd "${0%/*}"
cd ../python/

python3 ./index_generator.py -p /home/public/demos -t "PyCav Demos Index"
python3 ./index_generator.py -p /home/public/data -t "PyCav Data Notebooks"
python3 ./index_generator.py -p /home/public/investigations -t "PyCav Investigations Notebooks"

mv /home/public/demos/indexgen.ipynb /home/public/demos/index.ipynb
mv /home/public/data/indexgen.ipynb /home/public/data/index.ipynb
mv /home/public/investigations/indexgen.ipynb /home/public/investigations/index.ipynb 
