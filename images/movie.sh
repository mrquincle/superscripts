#!/bin/sh

# This script is used from libreoffice/openoffice to be able to show a movie at once
# at the right screen and in fullscreen during a presentation.
#
# To that end create macro's in libreoffice and assign "movie.sh yourchoice" as the
# action it needs to execute

# Check if we have a proper number of argument
if [[ "$1" == "" ]]
then
	echo "No args supplied! Run $0 -h for more info"
	exit 1
fi

# Provide help
if [[ "$1" == "-h" ]]
then
	echo "Perform $0 filename to play the file"
	echo "Perform $0 -l to see a list of files"
	exit 1
fi

SCREEN_NR=1

MOVIE_DIR=${HOME}/mymovies

MOVIE=$1

echo "Working path is: ${MOVIE_DIR}"
if [[ "$1" == "-l" ]]
then
	ls -latr ${MOVIE_DIR}	
	exit 1
fi

vlc --qt-fullscreen-screennumber=$SCREEN_NR --play-and-exit -f $MOVIE_DIR/$MOVIE

