#!/bin/sh

ADB_PATH="./Library/Android/sdk/platform-tools"

$ADB_PATH/adb shell "/system/bin/settings put global settings_enable_monitor_phantom_procs false"