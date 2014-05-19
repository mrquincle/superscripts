#!/bin/bash

# Go through tweets, get the GPS location and retrieve weather

# http://api.wunderground.com/auto/wui/geo/GeoLookupXML/index.xml?query=37.76834106,-122.39418793

# http://bugs.openweathermap.org/projects/api/wiki/Api_2_5_history

# e.g. http://api.openweathermap.org/data/2.5/history/city?id=2885679&type=hour&start=1369728000&cnt=1

# things like this are possible with http://trentm.com/json
# json statuses | json text -a geo -d',' | grep -v null

subdir="${1:? '$0 requires subdir as argument'}"

dir="/data/tweets/$subdir"

cd "$dir/items"

files=Individual*

shopt -s nullglob

for f in $files; do
	shopt -u nullglob

	# coordinates in twitter data stream is opposite of geo, weird! so first long (4.4), then lat(51.9)
	test=$(< "$f" underscore extract coordinates)
	if [ "$test" == "null" ]; then
		continue;
	fi
	timefile="Unixtime $f"
	# source command here requires bash, and not only sh
	source "$timefile"
	
	geo=$(< "$f" underscore extract coordinates.coordinates | tr -d '[' | tr -d ']' | tr -d ' ')
	long=$(echo $geo | cut -f1 -d',')
	lat=$(echo $geo | cut -f2 -d',')
	# The following is not possible, "history" is only provided for "city" and "station".
	# "curl -s http://api.openweathermap.org/data/2.5/history/weather?lat=$lat&lon=$long&units=metric"
	echo "curl -s http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&units=metric&type=hour&start=$unixtime&cnt=1"
	
	curl -s "http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&units=metric&type=hour&start=$unixtime&cnt=1" -o /tmp/weather.log
	file="Weather ${f##*/}"
	< /tmp/weather.log underscore print > "$file"
done

