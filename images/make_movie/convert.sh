#!/bin/bash

if [ $# -lt 1 ]
then
  echo "Input directory name is e.g. festo"
  read input
else
  input=$1
fi

nonamemask=000

newprefixname=${input}

# Use the directory where the script resides as relative directory to 
# define where "animate" and "extract" are at
dir=`dirname "$0"`
dir=`( cd "${dir}" && pwd )`

# Place them in the "animate" directory
mkdir -p "${dir}/../animate/${input}"

# Get the files from the "extract" directory
cd "${dir}/../extract/${input}"

echo "Converting all $nonamemask*.jpg files to eps files..."
for f in ${nonamemask}*.jpg; do 
	convert -quality 100 $f ${newprefixname}_`basename $f .jpg`.eps; 
done

mv *.eps "${dir}/../animate/${input}"

echo "Now remove subsequently ${newprefixname}_ and leading zeros again..."

cd "${dir}/../animate/${input}"
rename "s/${newprefixname}_0*//" *.eps

