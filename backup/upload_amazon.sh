#!/bin/bash

exclude_file=$(pwd)/upload_excludes.txt

echo "Upload $HOME directory"
cd $HOME

fake=--dry-run
# actually sync
fake=

size=$(du -s -h $HOME --exclude-from=$exclude_file | cut -f1)

day=$(date)

echo "Directory to sync: $HOME is size $size"
touch ~/.upload_amazon
cat ~/.upload_amazon

echo "Press any key to continue (Ctr+C to quit)"
read key

echo "Size at $day was $size" > ~/.upload_amazon

s3cmd $fake --no-encrypt --skip-existing --recursive --delete-removed --exclude-from=$exclude_file sync . s3://dottix
