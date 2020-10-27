#!/bin/bash

# See https://www.pivotaltracker.com/help/api/rest/v5

source ~/.config/pivotal

baseurl=https://www.pivotaltracker.com/services/v5/projects/$PIVOTAL_PROJECT

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
reset=$(echo -e "\e[0m")

mkdir -p tmp

# Get current iteration
curl -s -X GET -H "X-TrackerToken: $PIVOTAL_TOKEN" "$baseurl/iterations?scope=current_backlog" -o tmp/result.json

# Also get owners
baseurl=https://www.pivotaltracker.com/services/v5/my/people?project_id=$PIVOTAL_PROJECT
curl -s -X GET -H "X-TrackerToken: $PIVOTAL_TOKEN" "$baseurl" -o tmp/result_people.json 

column_width=77

extract() {
	echo -n "${ocolor}" > $ofile
	printf '=%.0s' {1..77} >> $ofile
	echo "${reset}" >> $ofile
	printf ' %.0s' {1..35} >> $ofile
	echo "${ocolor}${label}${reset}" >> $ofile
	echo -n "${ocolor}" >> $ofile
	printf '=%.0s' {1..77} >> $ofile
	echo "${reset}" >> $ofile
	cat tmp/result.json | jq -r "$jq_query" | tr '[]' '{}' >> $ofile
}

jq_query='.[].stories[] | select(.current_state=="unstarted") | [.name, .owner_ids] | "\(.[0]) \(.[1])"'
ofile=tmp/stage1.txt
ocolor=${red}
label="To Do"

extract

jq_query='.[].stories[] | select(.current_state=="started") | [.name, .owner_ids] | "\(.[0]) \(.[1])"'
ofile=tmp/stage2.txt
ocolor=${blue}
label="Doing"

extract

jq_query='.[].stories[] | select(.current_state=="delivered") | [.name, .owner_ids] | "\(.[0]) \(.[1])"'
ofile=tmp/stage3.txt
ocolor=${green}
label="Done"

extract

find tmp -type f -name "stage*.txt" -exec grep -H -c '[^[:space:]]' {} \; | sort -nr -t":" -k2 > tmp/lines.txt

maxlines=$(cat tmp/lines.txt | awk -F: '{print $2; exit;}')

while read p; do
	lines=$(echo $p | cut -f2 -d':')
	addlines=$(( $maxlines - $lines ))
	file=$(echo $p | cut -f1 -d':')
	for i in $(seq 1 $addlines); do
		echo >> $file
	done
done < tmp/lines.txt

cat tmp/result_people.json| jq -r '.[].person | [.id, .name] |  "\(.[0])/\(.[1])"' | cut -f1 -d' ' | tr '[:upper:]' '[:lower:]' > tmp/replace_ids.txt

while read p; do
	file=$(echo $p | cut -f1 -d':')
	while read id; do
		sed -i "s/$id/g" $file
	done < tmp/replace_ids.txt
	sed -i "s/{/(${purple}/g" $file
	sed -i "s/}/${reset})/g" $file
done < tmp/lines.txt

# Add column | symbols and add space before first column
sed -i 's/^/ /g' tmp/stage1.txt
sed -i 's/^/|  /g' tmp/stage2.txt
sed -i 's/^/|  /g' tmp/stage3.txt

# Must be last thing that has to be done
paste tmp/stage1.txt tmp/stage2.txt tmp/stage3.txt | column -t -s $'\t'

