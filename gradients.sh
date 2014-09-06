#!/bin/bash
# create gradients from json source

# depends on: convert parallel

# variables
OUTPUTDIR="./Gradients" # output directory
WIDTH="1680"   # widthxheight; rMBP-13: 1680x1050, iPhone:1136x640
HEIGHT="1050"

# create output dir
mkdir -p "$OUTPUTDIR"

# get colours and names, clean'm, loop'm, echo'm
while read -r line; do
  # create variables
  GRADIENT="$(echo "$line" | awk '{print $1 "-" $2}')"
  NAME="$(echo "$line" | cut -d " " -f 3-)"
  # command
  echo "convert -size "${WIDTH}x${HEIGHT}" radial-gradient:\"$GRADIENT\" ./Gradients/\"${NAME}-radial.png\""
done <<< "$(curl https://raw.githubusercontent.com/Ghosh/uiGradients/master/gradients.json | \
            jq '.[] | .colour1 + " " + .colour2 + " " + .name' | \
            sed 's/\"//g')" | \
            parallel
