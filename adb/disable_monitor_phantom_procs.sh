#!/bin/sh

ADB_PATH="/home/roberto/Android/sdk/platform-tools"

$ADB_PATH/adb shell "/system/bin/settings put global settings_enable_monitor_phantom_procs false"