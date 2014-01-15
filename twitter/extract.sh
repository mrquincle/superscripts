#!/bin/sh

subdir="${1:? '$0 requires subdir as argument'}"

dir="/data/tweets/$subdir"

cd "$dir"

mkdir -p items

cp *.pretty.log items

cd items

shopt -s nullglob

files=*.pretty.log

for f in $files; do
	echo "Split file $f"
	base="Individual ${f%.*.*} - "
	< $f underscore extract statuses | csplit - -s -n6 -f "$base" '/metadata/-1' '{*}'
done

rm $files

rm *00000

results=Individual*
for f in $results; do
	#echo "Remove comma or ] token from last line in file $f"
	sed -i -e '$s|,||' "$f"
	sed -i -e '$s|]||' "$f"
done

# write time stamps in unix time

results=Individual*
for f in $results; do
	#echo "< "$f" underscore extract created_at"
	timeslot=$(< "$f" underscore extract created_at | tr -d '"')
	#echo 'date -d "$timeslot" "+%s"'
	unixtime=$(date -d "$timeslot" "+%s")
	echo "unixtime=$unixtime" > "Unixtime $f"
done
