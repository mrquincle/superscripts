#!/bin/bash

path=$HOME/setup

# wait indefinitely, do not quit after
flags="-m --format '%w %f'"
flags="--format %f"

while true; do

echo "inotifywait $flags -e close_write $path" 
download=$(inotifywait $flags -e close_write $path)
 
echo $download 

mime=$(file -b --mime-type "$path/$download")

if [ "$mime" = "application/pdf" ]; then

	acroread "$path/$download"
fi
 

done
