#!/bin/sh

usage="$0 input.md template.html output.html"
ifile=${1:? "$usage"}
template=${2:? "$usage"}
ofile=${3:? "$usage"}

mkdir -p tmp

# The following was installed by npm and uses https://github.com/cwjohan/markdown-to-html
# Tables are not supported though
#markdown "$ifile" -f gfm > "tmp/content.html"

# Install by npm 
showdown makehtml -i "$ifile" -o "tmp/content.html" --tables

sed -e '/{{ contents }}/ {' -e 'r tmp/content.html' -e 'd' -e '}' "$template" > "$ofile"
