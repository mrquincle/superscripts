#!/bin/bash

# This script does cut a large movie into several smaller pieces for example to be send over an email
# or to put it in a repository

# It uses ffmpeg for this, so it won't work with any binary file, just .mpeg files

if [[ "$1" == "" ]]
then
	echo "Use $0 filename to cut it into pieces"
	exit 1
fi

filename=$1

source=$filename.MP4

target=$filename.PIECE

duration=`ffmpeg -i $source 2>&1 | grep "Duration" | cut -d ' ' -f 4 | sed s/,//`

echo $duration

minutes_floor=`echo $duration | cut -d ':' -f 2`

let "minutes=${minutes_floor}+1"

echo $minutes

counter=0

# call with number of minutes such as 71 and returns string like 01:11:00 (one hour and 11 minutes)
function seconds2string() {
	local __resultm2s=$1
	local myresultm2s

	let "myhours=${__resultm2s} / (60 * 60)"
	let "myhours_low=$myhours % 10"
	let "myhours_hi=($myhours - $myhours_low) / 10"

	let "myminutes=(${__resultm2s} - ${myhours}*60*60 ) / 60"
	let "myminutes_low=$myminutes % 10"
	let "myminutes_hi=($myminutes - $myminutes_low) / 10"

	let "myseconds=${__resultm2s} - ${myhours}*60*60 - ${myminutes}*60"
	let "myseconds_low=$myseconds % 10"
	let "myseconds_hi=($myseconds - $myseconds_low) / 10"

	myresultm2s="${myhours_hi}${myhours_low}:${myminutes_hi}${myminutes_low}:${myseconds_hi}${myseconds_low}"

	echo $myresultm2s
}

until [ "$counter" -eq "$minutes" ]; do
	let "counter_str=${counter}*60"

	start_time=$(seconds2string $counter_str)
	delta_time=$(seconds2string 60)

	ffmpeg -ss $start_time -t $delta_time -i $source -acodec copy -vcodec copy ${target}_$counter.MP4

  	let "counter=${counter}+1"
done
