kill -9 virgl_test_server_android termux-x11 pulseaudio

pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1

am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity

sleep 3

export DISPLAY=:0
termux-x11 :0 &

virgl_test_server_android &

proot-distro login archlinux --user user --shared-tmp -- bash -c "export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1; dbus-launch --exit-with-session startxfce4"

