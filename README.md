# Linux on Android
Linux distribution for Android.

## Install Termux
Install Termux, Termux-X11 and Termux Widget

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

### Setup Debian Linux

### Update system
Update Debian:
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
groupadd video
```

Create a regular user:
```
useradd -m -g users -G audio,storage,wheel,video -s /bin/bash user
passwd user
```

Add the new user to `/etc/sudoers`, running `visudo` and inserting the following line just after `root ALL=(ALL:ALL) ALL`:
```
user ALL=(ALL:ALL) ALL
```
To insert the line press key `[i]`, type the code and press keys `[ESC]`, `[:]`, `[w]`, `[q]` and `[ENTER]`, to save the file.

Setup the locale, language, time zone and chaset, (for example America/Bahia):
```
ln -sf /usr/share/zoneinfo/America/Bahia /etc/localtime
```

Edit /etc/locale.gen to setup your charset:
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

