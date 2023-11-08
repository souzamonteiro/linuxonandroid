#!/bin/sh

ADB_PATH="./Library/Android/sdk/platform-tools"

$ADB_PATH/adb shell "/system/bin/device_config set_sync_disabled_for_tests persistent"