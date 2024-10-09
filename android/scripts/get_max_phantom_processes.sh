#!/bin/sh

ADB_PATH="/home/roberto/Android/sdk/platform-tools"

$ADB_PATH/adb shell "/system/bin/device_config get activity_manager max_phantom_processes"
