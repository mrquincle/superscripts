#!/bin/bash

path=$HOME/setup
flags="--format %f"
while true; do
	download=$(inotifywait $flags -e close_write $path)
	file="$path/$download"
	extension="${file##*.}"
	if [ "$extension" != "pdf" ]; then
		echo "Extension is $extension while pdf is expected"
		continue
	fi
	mime=$(file -b --mime-type "$file")
	if [ "$mime" = "application/pdf" ]; then
		echo "Open $file"
		acroread "$file"
	fi
done
