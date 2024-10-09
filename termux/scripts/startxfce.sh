export DISPLAY=:0
export XDG_RUNTIME_DIR=${TMPDIR}

killall -9 termux-x11 virgl_test_server_android pulseaudio

pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1

virgl_test_server_android --angle-vulkan &
#virgl_test_server_android --angle-gl &
#virgl_test_server_android &

termux-x11 :0 -xstartup "dbus-launch --exit-with-session xfce4-session"
