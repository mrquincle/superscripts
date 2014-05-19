#!/bin/bash

# To check out things beforehand on twitter with respect to the right REST calls, use https://dev.twitter.com/console
# powered by Apigee by the way

# This script requires a dependency, namely twurl, for more information, see https://github.com/marcel/twurl. If you 
# dare, you can run the following script with sudo rights:
#  sudo gem i twurl --source http://rubygems.org
# You will have to do the following once:
#  twurl authorize -u $username -p $password --consumer-key $key --consumer-secret $secret

subdir="${1:? '$0 requires subdir as argument'}"

source twitter.config

# the given subdir is in reference to the following workpath: /data/tweets
mkdir -p "$data_dir/$subdir"
filename="$data_dir/$subdir/Tweets $term $(date)"

touch "$data_dir/since_id"
source "$data_dir/since_id"

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
echo "since_id=$since_id" > "$data_dir/since_id"

