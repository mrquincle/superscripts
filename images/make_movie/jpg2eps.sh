#!/bin/bash

if [ $# -lt 1 ]
then
  echo "File to convert, e.g. image.jpeg"
  read input
else
  input=$1
fi

s_input=`basename $input`
s_input=${s_input%.*}
convert -quality 100 $input ${s_input}.eps; 

