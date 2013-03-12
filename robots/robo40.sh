echo "Make sure you stopped the network manager and disabled wireless"
sudo stop network-manager 
route
# Create random ip on the right net
sudo ifconfig eth0 192.168.111.11

# Telnet to 192.168.111.23
telnet robo40
