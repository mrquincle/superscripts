#!/bin/bash

echo "Be careful... Don't do this too often or you are kicked off the network"

echo "sudo arp-scan -l" 

gksudo --description "Sorry, arp-scan needs sudo rights" -- arp-scan --localnet --interface=wlan0


