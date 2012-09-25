#!/bin/bash

echo "Use mplayer to create jpeg's from gif file, do not use convert"

# mplayer -vo jpeg FILENAME.gif 

# it's a pity that the -fps option is not understood for .MOV files 

# so you will have to use this:

# mplayer -vo jpeg -frames 200 -vf scale=320:240 -vf framestep=10 FILENAME.mov -nosound

# The frames 200 option limits the number of frames to 200... but it can be only 110 frames or so in the end

echo "Use something like this to create eps files"

NONAMEMASK=000
NEWPREFIXNAME="epuck"

echo "Converting all $NONAMEMASK*.jpg files to eps files..."
for f in ${NONAMEMASK}*.jpg; do 
	convert -quality 100 $f ${NEWPREFIXNAME}_`basename $f .jpg`.eps; 
done

mkdir -p ${NEWPREFIXNAME}_eps
mv *.eps ${NEWPREFIXNAME}_eps

echo "Now remove subsequently ${NEWPREFIXNAME}_ and leading zeros again..."

cd ${NEWPREFIXNAME}_eps
rename "s/${NEWPREFIXNAME}_0*//" *.eps

exit

# Undo options / directions

echo "This would add ${NEWPREFIXNAME}_ again in case your not satisfied (not tested!)"
for f in *.eps; do 
	mv $f ${NEWPREFIXNAME}_$f
done

