#!/bin/bash

# Configuration parameters are read from twitter.config
source twitter.config

# A list of directories that can be used 
dirs=dirs.txt

p=$(pwd)
rf=$p/dataset_twitter_running_weather.txt
mkdir -p backup
mv "$rf" "backup/$(date).table"
touch "$rf"

echo "Twitter combined with weather data (unordered)"
echo "----------------------------------------------------------------------------------------------------" >> "$rf"
echo "temp(C) | humidity(%) | wind speed | rain (over 3hrs) | clouds (%) | user id | time | coordinates (long,lat) | message" >> "$rf"
echo "----------------------------------------------------------------------------------------------------" >> "$rf"

# Reach the dirs.txt line by line
while read line; do
	subdir="$line"

	dir="$data_dir/$subdir"

	if [ ! -d "$dir" ]; then
		echo "The directory \"$dir\" does not exist"
		continue;
	else 
		echo "Check directory \"$dir\""
	fi

	cd "$dir/items"

	files=Weather*
	ls_w=$(ls Weather*)
	if [[ ! $ls_w ]]; then
		echo "There are no weather files, skip to next folder"
		continue;
	fi

	for f in $files; do
		values=$(< "$f" json main.temp main.humidity wind.speed rain.3h clouds.all)

		prefix="Weather "
		twitfile="${f#$prefix}"
		#cat "$twitfile"
		text=$(< "$twitfile" json text)
		other=$(< "$twitfile" json user.id created_at coordinates.coordinates)

		echo $values $other \"$text\" >> "$rf"
		#exit
	done

done < "$dirs"
echo "----------------------------------------------------------------------------------------------------" >> "$rf"

cat "$rf"
