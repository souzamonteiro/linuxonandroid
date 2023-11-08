#!/bin/sh

ADB_PATH="./Library/Android/sdk/platform-tools"

$ADB_PATH/adb shell "/system/bin/device_config set_sync_disabled_for_tests persistent"
$ADB_PATH/adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"
$ADB_PATH/adb shell "/system/bin/settings put global settings_enable_monitor_phantom_procs false"