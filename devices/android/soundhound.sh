#!/bin/sh

echo "Start SoundHound"
adb shell am start -n com.melodis.midomiMusicIdentifier.freemium/com.soundhound.android.appcommon.activity.SoundHound

echo "Click to recognize song"
adb shell input tap 400 400

sleep 15

#echo "Click to stop recognizing song"
#adb shell input tap 400 400

#sleep 2

echo "Click to share recognized song"
adb shell input tap 600 120

time=$(date)

sleep 10

text="Song recognized @wieodr [$time]"
echo "Send text: $text"
perl sendtext.pl "$text"

sleep 3

echo "Click to share recognized song on twitter"
adb shell input tap 600 120

sleep 20

echo "Kill SoundHound"
adb shell am force-stop com.melodis.midomiMusicIdentifier.freemium

