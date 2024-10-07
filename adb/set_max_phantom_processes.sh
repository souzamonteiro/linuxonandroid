#!/bin/sh

ADB_PATH="/home/roberto/Android/sdk/platform-tools"

$ADB_PATH/adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"