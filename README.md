# Linux on Android
Linux distribution for Android.

## Install Termux
Install Termux, Termux-X11 and Termux Widget.

### Setup Android
Android has a mechanism that monitors and kills forked child processes started by apps, the *Phantom Process Killer (PPF)*. You must disable it to run Linux processes in Termux, or they will crash frequently.

To disable the *Phantom Process Killer*, toggle *Settings -> Developer options -> Disable child process restrictions*. However, *Developer options* are not visible by default. To display them, go to *Settings -> About device -> Software information* and tap on *Build number* seven times.

This is not permanent. To make the changes permanent, install the *Android SDK* and run the following commands in a terminal, with your device connected to your computer using a USB cable:
```
$ADB_PATH/adb shell "/system/bin/device_config set_sync_disabled_for_tests persistent"
$ADB_PATH/adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"
$ADB_PATH/adb shell "/system/bin/settings put global settings_enable_monitor_phantom_procs false"
```
Where `ADB_PATH` is set to the path of your *Android SDK Platform Tools*. Enable *USB debugging* in *Developer options* before run the `adb` command.

### Install Termux
Download Termux from GitHub: [https://github.com/termux/termux-app/releases/download/v0.118.1/termux-app_v0.118.1+github-debug_arm64-v8a.apk]

Double-click the downloaded file, allow installation and install it.

### Install Termux-X11
Download Termux-X11 from GitHub: [https://github.com/termux/termux-x11/releases/download/nightly/app-arm64-v8a-debug.apk]

Double-click the downloaded file, allow installation and install it.

### Install Termux Widget
Download Termux-Widget from GitHub: [https://github.com/termux/termux-widget/releases/download/v0.13.0/termux-widget_v0.13.0+github-debug.apk]

Double-click the downloaded file, allow installation and install it.

## Setup Termux

### Upgrade Termux
Upgrade system:
```
pkg update -y
pkg upgrade -y
```

### Setup device storage access
Enable access to device storage:
```
termux-setup-storage
```

### Install Vim
Install Vim editor:
```
pkg install vim -y
```

### Install PRoot Distro
Install the proot-distro script for easy management of chroot-based Linux distribution installations:
```
pkg install proot-distro -y
```

### Install Termux-X11
Install X11 for Android:
```
pkg install x11-repo -y
pkg install termux-x11-nightly -y
```

### Install PulseAudio
Install audio support:
```
pkg install pulseaudio -y
```

### Setup hardware acceleration
Install VirGL and Angle:
```
pkg install angle-android virglrenderer-android
```

## Install and setup Debian

### Install Debian
Install Debian Linux:
```
proot-distro install debian
```

### Login
Login into system:
```
proot-distro login debian --user root --shared-tmp
```

### Update system packages list
Update the Debian packages list:
```
apt update -y
```

### Install system
Install basic programs:
```
apt install sudo vim firefox-esr -y
```

Install Xfce desktop:
```
apt install xfce4 xfce4-goodies dbus-x11 -y
```

Install locales:
```
apt install locales fonts-noto-cjk -y
```

### Setup system
Setup `root` password:
```
passwd
```

Add some needed groups:
```
groupadd storage
groupadd wheel
```

Create a regular user:
```
useradd -m -g users -G audio,storage,sudo,wheel,video -s /bin/bash user
passwd user
```

Add the new user to `/etc/sudoers`, running `visudo` and inserting the following line just after `root ALL=(ALL:ALL) ALL`:
```
user ALL=(ALL:ALL) ALL
```
To insert the line press key `[i]`, type the code and press keys `[ESC]`, `[:]`, `[w]`, `[q]` and `[ENTER]`, to save the file.

Setup the locale, language, time zone and charset, (for example America/Bahia):
```
ln -sf /usr/share/zoneinfo/America/Bahia /etc/localtime
```

Edit `/etc/locale.gen` to setup your charset:
```
vim /etc/locale.gen
```
Uncomment your charset, removing the hash character `#` from the start of the line (for example `pt_BR.UTF-8 UTF-8`). To do so, press key `[i]`, uncomment the code and press keys `[ESC]`, `[:]`, `[w]`, `[q]` and `[ENTER]`, to save the file.

Genarate the locales and setup your language:
```
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

### Exit system
Exit Debian:
```
exit
```

### Start Debian
To start Debian, launch Termux-X11 and in Termux Terminal, run the following commands:
```
export DISPLAY=:0
export XDG_RUNTIME_DIR=${TMPDIR}

pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1

virgl_test_server_android &

termux-x11 :0 -ac &

proot-distro login debian --user user --shared-tmp --no-sysvipc -- bash -c "export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1; dbus-launch --exit-with-session startxfce4"
```

### Install development tools
Install *build-essential*, a package that contains tools and headers required to compile packages in Debian:
```
sudo apt install build-essential -y
```

### Install OpenGL tools
Install *mesa-utils*, a package that contains tools to test the 3D hardware acceleration:
```
sudo apt install mesa-utils -y
```

### Install productivity tools
Install *Gimp*, *Inkscape*, *Scribus*, *LibreOffice*, *LibreCAD* and *Calibre*:
```
sudo apt install gimp inkscape scribus libreoffice librecad calibre -y
```

### Setup Firefox to use 3D hardware acceleration
Create a directory `bin` in the user `home` directory:
```
cd ~
mkdir bin
```
Create an script to run Firefox usin VirGL:
```
vim ~/bin/firefox-virgl.sh
```
Type the following code inside the script:
```
#!/bin/sh

GALLIUM_DRIVER=virpipe MESA_GL_VERSION_OVERRIDE=4.6COMPAT MESA_GLES_VERSION_OVERRIDE=3.2 firefox
```
Press keys `[ESC]`, `[:]`, `[w]`, `[q]` and `[ENTER]`, to save the file.

Give execution permission to the file:
```
chmod 755 ~/bin/firefox-virgl.sh
```

Create an script to launch Firefox from the desktop:
```
vim ~/Desktop/Firefox.desktop
```
Type the following code inside the script:
```
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Name=Firefox
GenericName=Firefox
Exec=/home/user/bin/firefox-virgl.sh
Terminal=false
Icon=/usr/share/firefox-esr/browser/chrome/icons/default/default48.png
Type=Application
Categories=Application;Network;
Comment=Web browser
StartupNotify=false
```
Press keys `[ESC]`, `[:]`, `[w]`, `[q]` and `[ENTER]`, to save the file.

Give execution permission to the file:
```
chmod 755 ~/Desktop/Firefox.desktop
```
Right-click on the Firefox.desktop file on your desktop and give it execution permission.

### Setup Termux Widget
Right-click on the Android desktop and add the Termux Widget.

Launch Termux and create a directory `.shortcuts` in the Termux `home` directory:
```
mkdir .shortcuts
```
Create an script to launch Debian from the Termux Widget:
```
vim .shortcuts/Debian.sh
```
Type the following code inside the script:
```
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
```
Press keys `[ESC]`, `[:]`, `[w]`, `[q]` and `[ENTER]`, to save the file.

Give execution permission to the file:
```
chmod 755 .shortcuts/Debian.sh
```
Launch Debian tapping the label `Debian.sh` in tbe Termux Widget.
