#!/bin/bash

cd $HOME

fake=--dry-run
# actually sync
fake=

size=$(du -s -h $HOME --exclude='.*' | cut -f1)

day=$(date)

echo "Directory to sync: $HOME is size $size"
touch ~/.upload_amazon
cat ~/.upload_amazon
echo "Size at $day was $size" > ~/.upload_amazon

echo "Press any key to continue (Ctr+C to quit)"
read key

s3cmd $fake --no-encrypt --skip-existing --recursive --delete-removed --exclude=".*" sync . s3://dottix
