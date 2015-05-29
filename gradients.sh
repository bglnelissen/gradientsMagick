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

# MBPr 13 inch
OUTPUTDIR="./Output-Gradients" # output directory, .gitignore this
WIDTH="2560"   # rMBP-13
HEIGHT="1600"
OPTIONS=" -size \"${HEIGHT}x${WIDTH}\" -rotate 90 "

# iPhone
# OUTPUTDIR="./Output-Gradients-iPhone5" # iPhone 5
# WIDTH="640" 
# HEIGHT="1136"
# OPTIONS="-size \"${WIDTH}x${HEIGHT}\" "

# morf movements by raster size (larger the number, the more chance of movement, but movements can be small)
A=8
B=8
C=8

mkdir -p "$OUTPUTDIR"
# fetch json from repo and loop through gradients
while read -r line; do
  if [ -n "$line" ]; then
    # create variables
    # Dimensions
    # WIDTH=$(identify -ping -format '%W' "$IN" )
    # HEIGHT=$(identify -ping -format '%H' "$IN" )
    ASTART="$(((WIDTH/A) * $(( ( RANDOM % A ) + 1 )) ))"",""$(((HEIGHT/A) * $(( ( RANDOM % A ) + 1 )) ))"
    ASTOP="$(((WIDTH/A) *  $(( ( RANDOM % A ) + 1 )) ))"",""$(((HEIGHT/A) * $(( ( RANDOM % A ) + 1 )) ))"
    BSTART="$(((WIDTH/B) * $(( ( RANDOM % B ) + 1 )) ))"",""$(((HEIGHT/B) * $(( ( RANDOM % B ) + 1 )) ))"
    BSTOP="$(((WIDTH/B) *  $(( ( RANDOM % B ) + 1 )) ))"",""$(((HEIGHT/B) * $(( ( RANDOM % B ) + 1 )) ))"
    CSTART="$(((WIDTH/C) * $(( ( RANDOM % C ) + 1 )) ))"",""$(((HEIGHT/C) * $(( ( RANDOM % C ) + 1 )) ))"
    CSTOP="$(((WIDTH/C) *  $(( ( RANDOM % C ) + 1 )) ))"",""$(((HEIGHT/C) * $(( ( RANDOM % C ) + 1 )) ))"
    MORFCOMMAND=" -distort Shepards \" $ASTART $ASTOP $BSTART $BSTOP  $CSTART $CSTOP \" "
    DUSTYCOMMAND=" \( "$OPTIONS" xc: +noise Random -channel G -threshold 1% -separate +channel -transparent white -negate \) -compose Overlay -composite "
    
    GRADIENT="$(echo "$line" | awk '{print $1 "-" $2}')"
    NAME="$(echo "$line" | cut -d " " -f 3-)"
    # Let's roll
    FILENAME="$OUTPUTDIR""/""${NAME}"".png"
    if [ ! -f "$FILENAME" ]; then
      echo "mkdir -p \"$OUTPUTDIR\" && convert "$OPTIONS" gradient:\"$GRADIENT\" "$MORFCOMMAND" "$DUSTYCOMMAND" \"$FILENAME\" "
      
    fi
  else
    echo "No valid input"
    exit 1
  fi
done <<< "$(curl https://raw.githubusercontent.com/Ghosh/uiGradients/master/gradients.json | \
            jq '.[] | .colour1 + " " + .colour2 + " " + .name' | \
            sed 's/\"//g')"
            
echo "# ./gradients.sh | parallel"
