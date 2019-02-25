#!/bin/sh

usage="$0 input.md"
ifile=${1:? "$usage"}

mkdir -p tmp

markdown "$ifile" -f markdown > "tmp/content.html"
sed -e '/{{ contents }}/ {' -e 'r tmp/content.html' -e 'd' -e '}' mailchimp-template.html > campaign.html
