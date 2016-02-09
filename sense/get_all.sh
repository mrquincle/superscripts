#/bin/bash

sensor=${1:? "Usage: $0 sensor_id"}

start=1

echo "Only get first 100000 pages"
end=$(( $start + 100000 ))

result_folder=$sensor

counter=$start
until [ $counter -gt $end ]; do
	echo "./get.sh $sensor $counter"
	./get.sh $sensor $counter

	end_reached=$(< $result_folder/$counter.txt grep marpessa)

	if [ -n "$end_reached" ]; then
		echo "End reached!"
		exit
	fi
	counter=$(( $counter + 1 ))
done

