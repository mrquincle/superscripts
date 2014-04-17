#!/bin/bash

# Check if we have a proper number of argument
if [[ "$1" == "" ]]; then
	echo "No args supplied! Run $0 -h for more info"
	exit 1
fi

# Provide help
if [[ "$1" == "-h" ]]; then
	echo "Perform $0 \"robot hostname\" to connect to the robot"
	exit 1
fi

ROBOT=$1

connect() {
	echo "* We will connect to \"$ROBOT\""
	touch /tmp/last_log.txt
	cp /tmp/last_log.txt /tmp/last_log.backup.txt
	echo "* Started netcat on port 10001"
	echo "* If no reponse, first hit \"Enter\""
	echo "* If still no response, restart robot and run this script again (one restart is not weird...)"
	nc $ROBOT 10001 | tee /tmp/last_log.txt
}

get_ip_adress() {
	echo "* We will use \"$ROBOT\" to retrieve the IP address of the robot"
	echo "* We assume there is an entry for \"$ROBOT\" in /etc/hosts"
	IP_ADDRESS=`cat /etc/hosts | grep -i $ROBOT | grep -v '#'`
	echo "* Found ip address: \"$IP_ADDRESS\" (if empty, check /etc/hosts)"
	if [ "$IP_ADDRESS" = "" ]; then
		echo "Sorry, set hostname (and IP address) in /etc/hosts"
		exit 37
	else 
		echo "* Ping robot $ROBOT (at $IP_ADDRESS)"
	fi
}

ping_robot() {
	PING=`ping -a -W 2 -c 1 $ROBOT`
	CONNECTION=`echo $PING | grep "1 received"`
	if [ "$CONNECTION" != "" ]; then
		echo "Notice: We can ping the robot. Let's connect!"
		connect
		exit 0
	fi
}

get_essid() {
	echo "* Retrieve ESSID via iwlist wlan0 scan"
	ESSID_t=`sudo iwlist wlan0 scan | grep -i $ROBOT | cut --delimiter=':' -f2 | tr -s "\"" " "` 
	ESSID=`echo $ESSID_t | sed 's/^[ \t]*//;s/[ \t]*$//'`
	echo "* Found ESSID: $ESSID (if empty, \"sudo iwlist wlan0 scan\")"

	if [ "$ESSID" = "" ]; then
		echo "Sorry, cannot find the ESSID called \"$ROBOT\" (can be a mask and case insensitive)"
		exit
	fi
}

stop_network_manager() {
	echo "* Stop network manager if running"
	STATUS=`sudo status network-manager`
	NM_RUNNING=`echo $STATUS | grep running`
	if [ "$NM_RUNNING" = "" ]; then
		echo -n
	else
		echo "* Stop the network manager!"
		sudo stop network-manager
	fi
}

setup_wlan() {
	echo "* We will create an ad-hoc connection to the surveyor with essid \"$ESSID\""
	sudo ifconfig wlan0 down
	sleep 1
	sudo iwconfig wlan0 key off
	sudo iwconfig wlan0 essid "$ESSID" mode Ad-Hoc channel 11
	sudo ifconfig wlan0 169.254.0.1
	sleep 1
}

get_ip_adress
ping_robot
get_essid
stop_network_manager
setup_wlan
ping_robot
connect

#echo "* Open HTML console"
#firefox http://$ROBOT


