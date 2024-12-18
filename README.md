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

Instead of adding the user to the sudo group, you can add it directly to the sudoers user list. To add the new user to `/etc/sudoers`, run `visudo` and insert the following line just after `root ALL=(ALL:ALL) ALL`:
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
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf
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
Install *Gimp*, *Inkscape*, *Scribus*, *LibreOffice*, *LibreCAD*, *Calibre* and *Wings 3D*:
```
sudo apt install gimp inkscape scribus libreoffice librecad calibre wings3d -y
```

### Setup Firefox and Wings 3D to use 3D hardware acceleration
Create a directory `bin` in the user `home` directory:
```
cd ~
mkdir bin
```
Create an script to run Firefox using VirGL:
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

Create an script to run Wings 3D using VirGL:
```
vim ~/bin/wings3d-virgl.sh
```
Type the following code inside the script:
```
#!/bin/sh

GALLIUM_DRIVER=virpipe MESA_GL_VERSION_OVERRIDE=4.6COMPAT MESA_GLES_VERSION_OVERRIDE=3.2 wings3d
```
Press keys `[ESC]`, `[:]`, `[w]`, `[q]` and `[ENTER]`, to save the file.

Give execution permission to the file:
```
chmod 755 ~/bin/wings3d-virgl.sh
```
Create an script to launch Wings 3D from the desktop:
```
vim ~/Desktop/Wings3D.desktop
```
Type the following code inside the script:
```
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Name=Wings 3D
GenericName=Wings 3D
Exec=/home/user/bin/wings3d-virgl.sh
Terminal=false
Icon=/usr/share/icons/wings3d.xpm
Type=Application
Categories=Application;Graphics;
Comment=3D modeling tool
StartupNotify=false
```
Press keys `[ESC]`, `[:]`, `[w]`, `[q]` and `[ENTER]`, to save the file.

Give execution permission to the file:
```
chmod 755 ~/Desktop/Wings3D.desktop
```
Right-click on the Wings3D.desktop file on your desktop and give it execution permission.

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

## Install Win64 support
It is possible run Windows programs on an Android tablet using Box64 and Wine.

### Install Box86 and Box64

Add ARMHF support, "ARM hard float", a Debian port for ARM processors that have hardware floating point support:
```
sudo dpkg --add-architecture armhf
```

Install some required tools:
```
sudo apt install wget gpg
```

Add Box86 Debian repository:
```
sudo wget https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list
wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg 
```

Add Box64 Debian repository:
```
sudo wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list
wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg
```

Update apt-get packages list:
```
sudo apt update
```

Install Box86 and Box64:
```
sudo apt install box86-android
sudo apt install box64-android
```

### Install Wine

Install Wine dependencies:
```
sudo apt install libasound2:armhf libc6:armhf libglib2.0-0:armhf libgphoto2-6:armhf libgphoto2-port12:armhf \
        	libgstreamer-plugins-base1.0-0:armhf libgstreamer1.0-0:armhf libldap-2.5-0:armhf libopenal1:armhf libpcap0.8:armhf \
        	libpulse0:armhf libsane1:armhf libudev1:armhf libusb-1.0-0:armhf libvkd3d1:armhf libx11-6:armhf libxext6:armhf \
        	libasound2-plugins:armhf ocl-icd-libopencl1:armhf libncurses6:armhf libncurses5:armhf libcap2-bin:armhf libcups2:armhf \
        	libdbus-1-3:armhf libfontconfig1:armhf libfreetype6:armhf libglu1-mesa:armhf libglu1:armhf libgnutls30:armhf \
        	libgssapi-krb5-2:armhf libkrb5-3:armhf libodbc1:armhf libosmesa6:armhf libsdl2-2.0-0:armhf libv4l-0:armhf \
        	libxcomposite1:armhf libxcursor1:armhf libxfixes3:armhf libxi6:armhf libxinerama1:armhf libxrandr2:armhf \
        	libxrender1:armhf libxxf86vm1:armhf libc6:armhf libcap2-bin:armhf -y

sudo apt install libasound2:arm64 libc6:arm64 libglib2.0-0:arm64 libgphoto2-6:arm64 libgphoto2-port12:arm64 \
		libgstreamer-plugins-base1.0-0:arm64 libgstreamer1.0-0:arm64 libldap-2.5-0:arm64 libopenal1:arm64 libpcap0.8:arm64 \
		libpulse0:arm64 libsane1:arm64 libudev1:arm64 libunwind8:arm64 libusb-1.0-0:arm64 libvkd3d1:arm64 libx11-6:arm64 libxext6:arm64 \
		ocl-icd-libopencl1:arm64 libasound2-plugins:arm64 libncurses6:arm64 libncurses5:arm64 libcups2:arm64 \
		libdbus-1-3:arm64 libfontconfig1:arm64 libfreetype6:arm64 libglu1-mesa:arm64 libgnutls30:arm64 \
		libgssapi-krb5-2:arm64 libjpeg62-turbo:arm64 libkrb5-3:arm64 libodbc1:arm64 libosmesa6:arm64 libsdl2-2.0-0:arm64 libv4l-0:arm64 \
		libxcomposite1:arm64 libxcursor1:arm64 libxfixes3:arm64 libxi6:arm64 libxinerama1:arm64 libxrandr2:arm64 \
		libxrender1:arm64 libxxf86vm1:arm64 libc6:arm64 libcap2-bin:arm64 -y
```
Install Wine in `/opt` directory:
```
cd /opt
```
Download Wine:
```
sudo wget https://github.com/Kron4ek/Wine-Builds/releases/download/9.2/wine-9.2-x86.tar.xz
sudo wget https://github.com/Kron4ek/Wine-Builds/releases/download/9.2/wine-9.2-amd64.tar.xz
```
Unpack Wine:
```
sudo tar xvf wine-9.2-x86.tar.xz 
sudo mv wine-9.2-x86 wine32

sudo tar xvf wine-9.2-amd64.tar.xz 
sudo mv wine-9.2-amd64 wine64
```
Install Wine icon:
```
sudo mkdir -p wine/images
cd wine/images
sudo wget https://raw.githubusercontent.com/souzamonteiro/linuxonandroid/refs/heads/main/debian/images/wine.png
cd ../..
```

### Install DXVK
DXVK is a Vulkan-based translation layer for Direct3D 9/10/11.

Install DXVK dependencies:
```
sudo apt install mesa-vulkan-drivers mesa-vulkan-drivers:armhf libvulkan1 libvulkan1:armhf
```

Download DXVK:
```
wget https://github.com/doitsujin/dxvk/releases/download/v2.3.1/dxvk-2.3.1.tar.gz
```

Unpack DXVK:
```
tar xvf dxvk-2.3.1.tar.gz
```

### Create an script to setup DXVK
Create an script to setup DXVK for each new user.
```
sudo echo '#!/bin/bash
cp /opt/dxvk-2.3.1/x32/* ~/.wine/drive_c/windows/system32
cp /opt/dxvk-2.3.1/x32/* ~/.wine64/drive_c/windows/system32
cp /opt/dxvk-2.3.1/x64/* ~/.wine64/drive_c/windows/syswow64' > /usr/local/bin/setup_dxvk.sh
sudo chmod +x /usr/local/bin/setup_dxvk.sh
```

### Create scripts to run Wine
Create scripts to run Wine under Box64:
```
sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX64_NOBANNER=1
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/widl "$@"' > /usr/local/bin/widl
sudo chmod 755 /usr/local/bin/widl

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX86_NOBANNER=1
export BOX86_PATH=./:./bin/:$HOME/bin:/opt/wine32/bin/
export BOX86_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine32/lib/wine/i386-unix/:/opt/wine32/lib/wine/i386-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine32
export WINEARCH=win32
box86 /opt/wine32/bin/wineserver
box86 /opt/wine32/bin/wine "$@"' > /usr/local/bin/wine
sudo chmod 755 /usr/local/bin/wine

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX64_NOBANNER=1
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/wine64 "$@"' > /usr/local/bin/wine64
sudo chmod 755 /usr/local/bin/wine64

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX64_NOBANNER=1
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/wine64-preloader "$@"' > /usr/local/bin/wine64-preloader
sudo chmod 755 /usr/local/bin/wine64-preloader

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX64_NOBANNER=1
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/winebuild "$@"' > /usr/local/bin/winebuild
sudo chmod 755 /usr/local/bin/winebuild

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX64_NOBANNER=1
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/winedump "$@"' > /usr/local/bin/winedump
sudo chmod 755 /usr/local/bin/winedump

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX64_NOBANNER=1
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/winegcc "$@"' > /usr/local/bin/winegcc
sudo chmod 755 /usr/local/bin/winegcc

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX64_NOBANNER=1
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/wineserver "$@"' > /usr/local/bin/wineserver
sudo chmod 755 /usr/local/bin/wineserver

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX64_NOBANNER=1
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/wmc "$@"' > /usr/local/bin/wmc
sudo chmod 755 /usr/local/bin/wmc

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX64_NOBANNER=1
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/wrc "$@"' > /usr/local/bin/wrc
sudo chmod 755 /usr/local/bin/wrc
sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX86_NOBANNER=1
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/wmc "$@"' > /usr/local/bin/wmc
sudo chmod 755 /usr/local/bin/wmc

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX86_NOBANNER=1
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/wrc "$@"' > /usr/local/bin/wrc
sudo chmod 755 /usr/local/bin/wrc

sudo ln -sf /opt/wine64/bin/msidb /usr/local/bin/msidb
sudo ln -sf /opt/wine64/bin/msiexec /usr/local/bin/msiexec
sudo ln -sf /opt/wine64/bin/notepad /usr/local/bin/notepad
sudo ln -sf /opt/wine64/bin/regedit /usr/local/bin/regedit
sudo ln -sf /opt/wine64/bin/regsvr32 /usr/local/bin/regsvr32
sudo ln -sf /opt/wine64/bin/wineboot /usr/local/bin/wineboot
sudo ln -sf /opt/wine64/bin/winecfg /usr/local/bin/winecfg
sudo ln -sf /opt/wine64/bin/wineconsole /usr/local/bin/wineconsole
sudo ln -sf /opt/wine64/bin/winedbg /usr/local/bin/winedbg
sudo ln -sf /opt/wine64/bin/winefile /usr/local/bin/winefile
sudo ln -sf /opt/wine64/bin/winemaker /usr/local/bin/winemaker
sudo ln -sf /opt/wine64/bin/winemine /usr/local/bin/winemine
sudo ln -sf /opt/wine64/bin/winepath /usr/local/bin/winepath
```

### Install Winetricks
Download and install Winetricks:
```
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod 755 winetricks
sudo mv winetricks /usr/local/bin/
```

### Create shortcuts
Create a shortcuts to the Wine File Manager on the Xfce desktop:
```
cd ~/Desktop

echo '[Desktop Entry]
Name=Wine32 Explorer
Exec=bash -c "wine explorer"
Icon=/opt/wine/images/wine.png
Type=Application' > ~/Desktop/Wine32.desktop
chmod 755 ~/Desktop/Wine32.desktop
sudo cp ~/Desktop/Wine32.desktop /usr/share/applications/

echo '[Desktop Entry]
Name=Wine64 Explorer
Exec=bash -c "wine64 explorer"
Icon=/opt/wine/images/wine.png
Type=Application' > ~/Desktop/Wine64.desktop
chmod 755 ~/Desktop/Wine64.desktop
sudo cp ~/Desktop/Wine64.desktop /usr/share/applications/
```

### Setup Wine
Setup Wine:
```
wine64 wineboot
```

Setup DXVK:
```
setup_dxvk.sh
```
