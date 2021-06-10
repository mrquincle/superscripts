#!/bin/sh

usage="$0 file.html subject"

ifile=${1:? "$usage"}
subject=${2:? "$usage"}

mkdir -p tmp

sed -i "s/{{ title }}/$subject/g" $ifile

echo 'Create campaign online'
mc campaigns create --subject=''''"$subject"'''' --from-email='anne@crownstone.rocks' --from-name='Crownstone' --html-filename=''''"$ifile"'''' | tee tmp/log.txt

# print campaign id

campaign_id=$(cat tmp/log.txt | grep 'campaign' | grep 'id' | tr -d ' ' | cut -f2 -d'=')

echo "Campaign id: $campaign_id"

echo $campaign_id > tmp/campaign_id.txt
