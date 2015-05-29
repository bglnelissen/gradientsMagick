#!/bin/bash
IN=in.png
OUT=out.png

# Dimensions
WIDTH=$(identify -ping -format '%W' "$IN" )
HEIGHT=$(identify -ping -format '%H' "$IN" )

# morf movements by raster size (larger the number, the more chance of movement, but movements can be small)
A=8
B=8
C=8
ASTART="$(((WIDTH/A) * $(( ( RANDOM % A ) + 1 )) ))"",""$(((HEIGHT/A) * $(( ( RANDOM % A ) + 1 )) ))"
ASTOP="$(((WIDTH/A) *  $(( ( RANDOM % A ) + 1 )) ))"",""$(((HEIGHT/A) * $(( ( RANDOM % A ) + 1 )) ))"
BSTART="$(((WIDTH/B) * $(( ( RANDOM % B ) + 1 )) ))"",""$(((HEIGHT/B) * $(( ( RANDOM % B ) + 1 )) ))"
BSTOP="$(((WIDTH/B) *  $(( ( RANDOM % B ) + 1 )) ))"",""$(((HEIGHT/B) * $(( ( RANDOM % B ) + 1 )) ))"
CSTART="$(((WIDTH/C) * $(( ( RANDOM % C ) + 1 )) ))"",""$(((HEIGHT/C) * $(( ( RANDOM % C ) + 1 )) ))"
CSTOP="$(((WIDTH/C) *  $(( ( RANDOM % C ) + 1 )) ))"",""$(((HEIGHT/C) * $(( ( RANDOM % C ) + 1 )) ))"

MORFCOMMAND=$(echo convert "$IN" -distort Shepards \" "$ASTART" "$ASTOP" "   " \
                                                      "$BSTART" "$BSTOP" "   " \
                                                      "$CSTART" "$CSTOP" \
                                                   \" "$OUT")
echo "$MORFCOMMAND"
eval "$MORFCOMMAND"