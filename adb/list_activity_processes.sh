#!/bin/sh

ADB_PATH="./Library/Android/sdk/platform-tools"

$ADB_PATH/adb shell "/system/bin/dumpsys activity processes -a"
