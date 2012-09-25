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

echo "-----------------------------------------------------------------------------------------"
echo

# First exact the movies file to a directory
./extract.sh "$input" "$output"

echo
echo "-----------------------------------------------------------------------------------------"
echo
# Then convert to jpeg files
./convert.sh "$output"

echo
echo "-----------------------------------------------------------------------------------------"
echo
echo "To use this as pstrick"
echo
echo "  \usepackage{graphicx}"
echo "  \usepackage{animate}"
echo
echo "  \centerline{\animategraphics[width=6.5cm,autoplay,final]{20}{animate/festo/}{1}{144}}"
echo 
echo "Note that 20 defines the frame rate, and 144 denotes the last picture."
echo "I would recommend to comment the animategraphics commands till you are finished,"
echo "because the compilation of the pdf document becomes really slow"
echo
