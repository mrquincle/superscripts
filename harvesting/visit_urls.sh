#!/bin/sh

ifile=${1:? "Input file"}
url_start=${2:? "First url to retrieve"}
url_count=${3:? "Number of urls to retrieve"}
ofile="${ifile}.urls"


< $ifile cut -f4 | grep -v '^$' > $ofile

url_stop=$((url_start+url_count))

if [ "$url_start" -lt "1" ]; then
    echo "Index starts with 1"
    return 2;
fi

i=0
while read url; do
    i=$((i+1))
    if [ "$i" -ge "$url_stop" ]; then
	break;
    fi

    if [ "$i" -ge "$url_start" ]; then
        google-chrome "$url"
    fi

done < "$ofile"
