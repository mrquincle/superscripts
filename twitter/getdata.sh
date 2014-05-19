#!/bin/sh

# You will need to install some tools beforehand
#  npm install -g underscore-cli
#  npm install -g jsontools

# We create a new folder for our data, we subsequently run several scripts with this folder as an argument
folder_name="Search $(date)"

echo "$folder_name" >> dirs.txt

echo ./twitter.sh "$folder_name"
./twitter.sh "$folder_name"

echo ./extract.sh "$folder_name"
./extract.sh "$folder_name"

echo ./weather.sh "$folder_name"
./weather.sh "$folder_name"

