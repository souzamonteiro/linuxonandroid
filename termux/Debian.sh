killall -9 virgl_test_server_android termux-x11 pulseaudio

pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1

am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity

sleep 3

virgl_test_server_android --angle-gl &

export DISPLAY=:0
export XDG_RUNTIME_DIR=${TMPDIR}
termux-x11 :0 -ac &

proot-distro login debian --user user --shared-tmp -- bash -c "export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1; dbus-launch --exit-with-session startxfce4"

