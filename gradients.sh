#!/bin/bash
# Create beautiful png background gradients
# Use the json source from https://github.com/Ghosh/uiGradients

# depends on: convert jq parallel
# brew install imagemagick parallel jq

# get colours and names from the source
# convert the json to a bash readable input (#348F50 #56B4D3 Emerald Water)
# loop through each gradient and use convert (ImageMagick) to create a PNG
# Rotate -90 to create a nice horizontal gradient

# by default, the commands are printed to stdout
# use as:
# ./gradients.sh | parallel

# variables
OUTPUTDIR="./Output-Gradients" # output directory, .gitignore this
WIDTH="2560"   # rMBP-13
HEIGHT="1600"
# OUTPUTDIR="./Output-Gradients" # iPhone 5
OPTIONS="-size \"${HEIGHT}x${WIDTH}\"  -rotate 90"
# OUTPUTDIR="./Output-Gradients-iPhone5" # iPhone 5
# WIDTH="640" 
# HEIGHT="1136"
# OUTPUTDIR="./Output-Gradients" # iPhone 4
# WIDTH="640" 
# HEIGHT="960"
# OPTIONS="-size \"${WIDTH}x${HEIGHT}\" "

mkdir -p "$OUTPUTDIR"
# fetch json from repo and loop through gradients
while read -r line; do
  if [ -n "$line" ]; then
    # create variables
    GRADIENT="$(echo "$line" | awk '{print $1 "-" $2}')"
    NAME="$(echo "$line" | cut -d " " -f 3-)"
    # Let's roll
    FILENAME="$OUTPUTDIR""/""${NAME}"".png"
    if [ ! -f "$FILENAME" ]; then
      echo "mkdir -p \"$OUTPUTDIR\" && convert -size \"${HEIGHT}x${WIDTH}\" -rotate 90 gradient:\"$GRADIENT\" \"$FILENAME\" "
      echo "mkdir -p \"$OUTPUTDIR\" && convert $OPTIONS gradient:\"$GRADIENT\" \"$FILENAME\" "
    fi
  else
    echo "No valid input"
    exit 1
  fi
done <<< "$(curl https://raw.githubusercontent.com/Ghosh/uiGradients/master/gradients.json | \
            jq '.[] | .colour1 + " " + .colour2 + " " + .name' | \
            sed 's/\"//g')"
