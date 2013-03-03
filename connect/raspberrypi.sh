#!/bin/bash

#RASPBERRY_IP=192.168.1.105

echo "-------------------"
echo "Raspberry PI Script"
echo "-------------------"
echo "This program requires the installation of x2x on both your machine and the raspberry pi"
echo "To find the IP address of the raspberry pi it uses a MAC address here, adjust it."
echo "It requires arp-scan to find this IP address"

RASPBERRY_MAC=b8:27:eb:2d:df:a1

ARPSCANLOG=arpscan.log
sudo arp-scan -l -I wlan0 > $ARPSCANLOG

LINE=$(cat $ARPSCANLOG | grep $RASPBERRY_MAC)

RASPBERRY_IP=$(echo $LINE | cut -f1 -d' ')

echo "Connect to $RASPBERRY_IP"
echo "Type your password and move your mouse to the right"


ssh -X pi@$RASPBERRY_IP 'x2x -east -to :0'
