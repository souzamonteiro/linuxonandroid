#!/bin/sh

ADB_PATH="./Library/Android/sdk/platform-tools"

$ADB_PATH/adb shell "/system/bin/logcat -d > /sdcard/logcat.txt"