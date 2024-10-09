#!/bin/sh

ADB_PATH="/home/roberto/Android/sdk/platform-tools"

$ADB_PATH/adb shell "/system/bin/logcat -d > /sdcard/logcat.txt"