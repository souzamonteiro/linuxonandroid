export DISPLAY=:0
export XDG_RUNTIME_DIR=${TMPDIR}

am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity

sleep 3

killall -9 termux-x11 virgl_test_server_android pulseaudio

pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1

virgl_test_server_android --angle-vulkan &
#virgl_test_server_android --angle-gl &
#virgl_test_server_android &

termux-x11 :0 -ac &

proot-distro login debian --user user --shared-tmp --no-sysvipc -- bash -c "export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1; dbus-launch --exit-with-session startxfce4"

