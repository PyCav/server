#!/bin/bash

pandoc -s -V geometry:margin=0.8in --dpi=192  server_setup_guide.md -o setup.pdf
