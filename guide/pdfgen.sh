#!/bin/bash
cd "${0%/*}"
pandoc -s --variable urlcolor=blue -V geometry:margin=0.8in --dpi=192  server_setup_guide.md -o setup.pdf

if [ $? -eq 0 ]; then
    echo "setup.pdf has been successfully generated in the server/guide/ directory."
else
    echo "Pandoc failed to generate setup.pdf with error code: "$?"."
fi
