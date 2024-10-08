kill -9 virgl_test_server_android termux-x11 pulseaudio

pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1

am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity

sleep 3

virgl_test_server_android --angle-gl &

export DISPLAY=:0
export XDG_RUNTIME_DIR=${TMPDIR}
termux-x11 :0 -ac &

#proot-distro login debian --user user --shared-tmp -- bash -c "export DISPLAY=:0 GALLIUM_DRIVER=virpipe MESA_GL_VERSION_OVERRIDE=4.6COMPAT MESA_GLES_VERSION_OVERRIDE=3.2 dbus-launch --exit-with-session startxfce4 &"

#export DISPLAY=:0
#termux-x11 :0 &

#MESA_NO_ERROR=1 MESA_GL_VERSION_OVERRIDE=4.3COMPAT MESA_GLES_VERSION_OVERRIDE=3.2 GALLIUM_DRIVER=zink ZINK_DESCRIPTORS=lazy virgl_test_server --use-egl-surfaceless --use-gles &

#virgl_test_server_android &

proot-distro login debian --user user --shared-tmp -- bash -c "export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1; dbus-launch --exit-with-session startxfce4"

