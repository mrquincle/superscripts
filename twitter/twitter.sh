#!/bin/bash

# To check out things beforehand on twitter with respect to the right REST calls, use https://dev.twitter.com/console
# powered by Apigee by the way

# This script requires a dependency, namely twurl, for more information, see https://github.com/marcel/twurl. If you 
# dare, you can run the following script with sudo rights:
#  sudo gem i twurl --source http://rubygems.org
# You will have to do the following once:
#  twurl authorize -u $username -p $password --consumer-key $key --consumer-secret $secret

subdir="${1:? '$0 requires subdir as argument'}"

# the %23 is the # token
term=%23endomondo

# currently, we limit our search to a specific geocode lat long is 51.908868,4.479621 with radius of 200km
geocode=51.908868,4.479621,200km

# the given subdir is in reference to the following workpath: /data/tweets
dir="/data/tweets"
mkdir -p "$dir/$subdir"
filename="$dir/$subdir/Tweets $term $(date)"

touch "$dir/since_id"
source "$dir/since_id"

if [ $since_id ]; then
	restrictions="&since_id=$since_id";
fi

query=/1.1/search/tweets.json?q=$term\&geocode=${geocode}${restrictions}

twurl $query > "$filename.log"

echo $query > "$filename.query.log"

cat "$filename.log" | underscore print > "$filename.pretty.log"

echo "You can find the (pretty printed) tweets in $filename.pretty.log"

#echo "we will print here a bit of the file:"
#echo
#cat "$filename.log" | underscore print --color | head
#echo

# the last part of the file contains search_metadata
since_id=$(cat "$filename.pretty.log" | tail -n12 | grep "refresh_url" | cut -f2 -d'=' | cut -f1 -d'&')

echo "Next time only searches with since_id=$since_id"
echo "since_id=$since_id" > "$dir/since_id"

