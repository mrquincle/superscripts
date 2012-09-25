#!/bin/bash

# This script has not been tested, be careful!

# Use mplayer to create jpeg's from gif file, do not use convert
mplayer -vo jpeg sandpile_2D.gif 

# Use something like this to create eps files

MASK=000

echo "Converting all $MASK.ppm files..."
for f in $MASK*.jpg; do 
	convert -quality 100 $f soc_`basename $f .jpg`.eps; 
done

mkdir -p ${MASK}_eps
mv *.eps ${MASK}_eps

# This removes subsequently soc_ and leading zeros again...
rename 's/soc_0*//' *.jpg

# And this would add soc_ again (not tested)

for f in $MASK*.eps; do 
	mv $f soc_$f
done

# This script has not been tested!
