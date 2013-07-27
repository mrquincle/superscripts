#!/bin/sh

# Have an eternal while loop until the user presses cancel

while true; do

text=$(zenity --title="Whatsapp!" --entry --text="Type your whatsapp message\n (open it maximized)")

if [ -z "$text" ]; then
	echo "Thanks for using my software, please promote http://www.dobots.nl"
	exit
fi

#echo perl sendtext.pl "\"$text\""
perl sendtext.pl "$text"

# Following command needs tweaking for position
vertical=1100
horizontal=700
adb shell input tap $horizontal $vertical

done
