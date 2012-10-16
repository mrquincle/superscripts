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
	echo "* Started netcat on port 10001 (prompt should return to the user)"
	echo "* If no reponse, restart robot at run script again (my robot always required one restart)"
	nc $ROBOT 10001 | tee /tmp/last_log.txt
}

echo "* We will use \"$ROBOT\" to retrieve the IP address of the robot"
#echo '* Use e.g. "echo srv1 > robot_ip.txt" to connect to Surveyor robot "srv1"'
echo "* We assume there is an entry for \"$ROBOT\" in /etc/hosts"
IP_ADDRESS=`cat /etc/hosts | grep -i $ROBOT | grep -v '#'`
echo "* Found ip address: \"$IP_ADDRESS\" (if empty, check /etc/hosts)"

if [ "$IP_ADDRESS" = "" ]; then
	echo "Sorry, set hostname (and IP address) in /etc/hosts"
	exit
else 
	echo "* Ping robot $ROBOT (at $IP_ADDRESS)"
fi

PING=`ping -a -W 2 -c 1 $ROBOT`
#echo $PING
CONNECTION=`echo $PING | grep "1 received"`

if [ "$CONNECTION" != "" ]; then
	echo "Notice: We can already ping the robot. Let's connect"
	connect
	exit
fi

echo "* Retrieve ESSID via iwlist wlan0 scan"
ESSID_t=`sudo iwlist wlan0 scan | grep -i $ROBOT | cut --delimiter=':' -f2 | tr -s "\"" " "` 
ESSID=`echo $ESSID_t | sed 's/^[ \t]*//;s/[ \t]*$//'`
echo "* Found ESSID: $ESSID (if empty, \"sudo iwlist wlan0 scan\")"

if [ "$ESSID" = "" ]; then
	echo "Sorry, cannot find the ESSID called \"$ROBOT\" (can be a mask and case insensitive)"
	exit
fi

echo "* Stop network manager if running"
STATUS=`sudo status network-manager`
NM_RUNNING=`echo $STATUS | grep running`
if [ "$NM_RUNNING" = "" ]; then
	echo -n
else
	echo "* Stop the network manager!"
	sudo stop network-manager
fi

echo "* We will create an ad-hoc connection to the surveyor with essid \"$ESSID\""
sudo ifconfig wlan0 down
sleep 1
sudo iwconfig wlan0 key off
sudo iwconfig wlan0 essid "$ESSID" mode Ad-Hoc channel 11
sudo ifconfig wlan0 169.254.0.1
sleep 1

echo "* Ping the robot again"
ping -a -W 2 -c 1 $ROBOT
PING=`ping -a -W 2 -c 1 $ROBOT`
CONNECTION=`echo $PING | grep "1 received"`

if [ "$CONNECTION" != "" ]; then
echo
else 
echo "Error: Sorry, we cannot ping the robot"
echo "  Sometimes restarting robot works."
echo "  Just ping again using: \"ping $ROBOT -c 1\""
exit
fi

echo "* Successfully established connection"


#echo "* Open HTML console"
#firefox http://$ROBOT


