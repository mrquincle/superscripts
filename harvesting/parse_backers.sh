#!/bin/sh

echo Parse backer html file

file=${1:? "Use file as argument"}

cat $1 | grep 'profile/' | egrep -v 'img|class' | sed 's|</a>||g' | sed 's|">|\t|g' | sed 's|<a href="|https://www.kickstarter.com|g' > "${1}.out"
#| cut -f2-4 -d' ' | cut -f2 -d'>' | sed 's|</a||g' > "${1}.out"
