#!/bin/sh

usage="$0 <input file> <output file>"

ifile=${1:? "$usage"}
ofile=${2:? "$usage"}

dim=$(identify -format "%[fx:min(w,h)]" "${ifile}")

# You can adjust dim also to something smaller than dim above (min of heigh or length)
# Then it will crop the center of the image

convert "${ifile}" -gravity center -crop ${dim}x${dim}+0+0 -resize 200x200 +repage "$ofile"
