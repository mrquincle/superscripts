#!/bin/sh

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

while read line; do
	subdir="$line"

	dir="/data/tweets/$subdir"

	cd "$dir/items"

	files=Weather*

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
