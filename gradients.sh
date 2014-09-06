#!/bin/bash
# create gradients from json source

# depends on: convert parallel

# variables
OUTPUTDIR="./Output-Gradients" # output directory # .gitignore this
WIDTH="2560"   # rMBP-13
HEIGHT="1600"
iPhone5OUTPUTDIR="./Output-Gradients-iPhone5" # output directory # .gitignore this
iPhone5WIDTH="640" # iPhone5
iPhone5HEIGHT="1136"
iPhone4OUTPUTDIR="./Output-Gradients-iPhone4" # output directory # .gitignore this
iPhone4WIDTH="640" # iPhone4
iPhone4HEIGHT="960"

# get colours and names, clean'm, loop'm, echo'm
while read -r line; do
  # create variables
  GRADIENT="$(echo "$line" | awk '{print $1 "-" $2}')"
  NAME="$(echo "$line" | cut -d " " -f 3-)"
  # vertical
  # mkdir -p "$OUTPUTDIR" && echo "convert -size "${WIDTH}x${HEIGHT}" gradient:\"$GRADIENT\" "$OUTPUTDIR"/\""${NAME}"-vertical.png\""
  # horizontal
  mkdir -p "$OUTPUTDIR" && echo "convert -size "${HEIGHT}x${WIDTH}" gradient:\"$GRADIENT\" -rotate -90 "$OUTPUTDIR"/\""${NAME}"-horizontal.png\""
  # iPhone 5
  mkdir -p "$iPhone5OUTPUTDIR" && echo "convert -size "${iPhone5WIDTH}x${iPhone5HEIGHT}" gradient:\"$GRADIENT\" "$iPhone5OUTPUTDIR"/\""${NAME}".png\""
  # iPhone 4
  mkdir -p "$iPhone4OUTPUTDIR" && echo "convert -size "${iPhone4WIDTH}x${iPhone4HEIGHT}" gradient:\"$GRADIENT\" "$iPhone4OUTPUTDIR"/\""${NAME}".png\""
  # radial
  # mkdir -p "$OUTPUTDIR" && echo "convert -size "${WIDTH}x${HEIGHT}" radial-gradient:\"$GRADIENT\" "$OUTPUTDIR"/\""${NAME}"-vertical.png\""

done <<< "$(curl https://raw.githubusercontent.com/Ghosh/uiGradients/master/gradients.json | \
            jq '.[] | .colour1 + " " + .colour2 + " " + .name' | \
            sed 's/\"//g')" | \
            parallel
