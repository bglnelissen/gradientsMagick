#!/bin/bash
# create gradients from json source

# depends on: convert parallel

# variables
OUTPUTDIR="./Gradients" # output directory
DIMENSION="1680x1050"   # widthxheight

# create output dir
mkdir -p "$OUTPUTDIR"

# get colours and names, clean'm, loop'm, echo'm
while read -r line; do
  # create variables
  GRADIENT="$(echo "$line" | awk '{print $1 "-" $2}')"
  NAME="$(echo "$line" | cut -d " " -f 3-)"
  # command
  echo "convert -size "$DIMENSION" gradient:\"$GRADIENT\" ./Gradients/\"${NAME}.png\""
done <<< "$(cat gradients.json |  jq '.[] | .colour1 + " " + .colour2 + " " + .name' | sed 's/\"//g')" | parallel
