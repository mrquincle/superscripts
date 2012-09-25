#!/bin/bash

sudo stop network-manager 
sudo ifconfig wlan0 down
sudo iwconfig wlan0 mode ad-hoc 
sudo iwconfig wlan0 key off
sudo iwconfig wlan0 essid ardrone_network
sudo ifconfig wlan0 up
sudo dhcpcd wlan0
