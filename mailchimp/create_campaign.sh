#!/bin/sh

usage="$0 subject"

mkdir -p tmp

subject=${1:? "$usage"}

echo mc campaigns create --subject=''''"$subject"'''' --from-email='anne@crownstone.rocks' --from-name='Crownstone' --html-filename=campaign.html | tee tmp/log.txt
mc campaigns create --subject=''''"$subject"'''' --from-email='anne@crownstone.rocks' --from-name='Crownstone' --html-filename='mailchimp.html' | tee tmp/log.txt

campaign_id=$(cat tmp/log.txt | grep 'campaign' | grep 'id' | tr -d ' ' | cut -f2 -d'=')

echo "Campaign id: $campaign_id"

echo $campaign_id > tmp/campaign_id.txt
