#!/bin/bash

if [ $# -lt 2 ]
then
  echo "Input file is e.g. ../movies/festo.mp4"
  echo "Please, enter: "
  read input
else
  input=$1
fi

if [ $# -lt 1 ]
then
  echo "Output directory name is e.g. festo"
  echo "Please, enter: "
  read output
else
  output=$2
fi

# you can play around with the framestep if the result is not satisfying
mplayer -vo jpeg -frames 2000 -vf scale=480:385 -vf framestep=1 $input -nosound

mkdir -p ../extract/$output

mv *.jpg ../extract/$output
