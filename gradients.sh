#!/bin/bash
# create gradients from json source

# create output dir
mkdir -p ./Gradients

# get colours and names
COLOURS=$(cat gradients.json |  jq '.[] | .colour1 + " " + .colour2 + " " + .name')
for i in "${COLOURS[@]}";do
  echo $i
done

# create Gradients

# convert -size 1050x1680 gradient:yellow-green -rotate -90 output.png; open output.png

