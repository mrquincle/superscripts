#!/bin/bash

cd /opt/android-sdk-linux_x86/platform-tools/
./adb forward tcp:8000 tcp:8000
