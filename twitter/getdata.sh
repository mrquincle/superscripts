#!/bin/sh

# You will need to install some tools beforehand
#  npm install -g underscore-cli
#  npm install -g jsontools

folder_name="Search $(date)"

echo "$folder_name" >> dirs.txt

echo ./twitter.sh "$folder_name"
./twitter.sh "$folder_name"

echo ./extract.sh "$folder_name"
./extract.sh "$folder_name"

echo ./weather.sh "$folder_name"
./weather.sh "$folder_name"

