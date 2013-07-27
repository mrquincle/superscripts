#!/bin/sh

# Search for proper name if whatsapp changes its package name
#program=$(adb shell pm list packages | grep whatsapp | cut -d':' -f2)
#echo $program

# Start program
adb shell am start -n com.whatsapp/com.whatsapp.Main

sleep 1
echo "Pick first contact in the list"
vertical=200
horizontal=400
adb shell input tap $horizontal $vertical

echo "Navigate to the specific person you want to send a message to on your phone if the one that is currently opened is the wrong one"

# Have an eternal while loop until the user presses cancel
while true; do

text=$(zenity --title="Whatsapp!" --entry --text="Type your whatsapp message\n (open it maximized)")

if [ -z "$text" ]; then
	echo "Thanks for using my software, please promote http://www.dobots.nl"
	exit
fi

#echo perl sendtext.pl "\"$text\""
perl sendtext.pl "$text"

sleep 1

# Following command needs tweaking for position
vertical=1100
horizontal=700
adb shell input tap $horizontal $vertical

done
