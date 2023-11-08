#!/bin/sh

ADB_PATH="./Library/Android/sdk/platform-tools"

$ADB_PATH/adb shell "/system/bin/device_config get activity_manager max_phantom_processes"
