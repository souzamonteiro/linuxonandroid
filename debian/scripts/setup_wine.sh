#!/bin/sh

# Install box64.

# Add ARMHF support, "ARM hard float", a Debian port for ARM processors that have hardware floating point support.
sudo dpkg --add-architecture armhf

# Install some required tools.
sudo apt install wget gpg -y

# Add box64 Debian repository.
sudo wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list
wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg

# Update apt-get packages list.
sudo apt update -y

# Install box64.
sudo apt install box64-android -y

# Install Wine.

# Install Wine dependencies.
sudo apt install libasound2:arm64 libc6:arm64 libglib2.0-0:arm64 libgphoto2-6:arm64 libgphoto2-port12:arm64 \
		libgstreamer-plugins-base1.0-0:arm64 libgstreamer1.0-0:arm64 libldap-2.5-0:arm64 libopenal1:arm64 libpcap0.8:arm64 \
		libpulse0:arm64 libsane1:arm64 libudev1:arm64 libunwind8:arm64 libusb-1.0-0:arm64 libvkd3d1:arm64 libx11-6:arm64 libxext6:arm64 \
		ocl-icd-libopencl1:arm64 libasound2-plugins:arm64 libncurses6:arm64 libncurses5:arm64 libcups2:arm64 \
		libdbus-1-3:arm64 libfontconfig1:arm64 libfreetype6:arm64 libglu1-mesa:arm64 libgnutls30:arm64 \
		libgssapi-krb5-2:arm64 libjpeg62-turbo:arm64 libkrb5-3:arm64 libodbc1:arm64 libosmesa6:arm64 libsdl2-2.0-0:arm64 libv4l-0:arm64 \
		libxcomposite1:arm64 libxcursor1:arm64 libxfixes3:arm64 libxi6:arm64 libxinerama1:arm64 libxrandr2:arm64 \
		libxrender1:arm64 libxxf86vm1:arm64 libc6:arm64 libcap2-bin:arm64 -y
  
# Install Wine in `/opt` directory.
cd /opt

# Download Wine.
sudo wget https://github.com/Kron4ek/Wine-Builds/releases/download/9.19/wine-9.19-amd64-wow64.tar.xz

# Unpack Wine.
sudo tar xvf wine-9.19-amd64-wow64.tar.xz
sudo mv wine-9.19-amd64-wow64 wine64

# Install DXVK a Vulkan-based translation layer for Direct3D 9/10/11.

# Install DXVK dependencies.
sudo apt install mesa-vulkan-drivers mesa-vulkan-drivers:armhf libvulkan1 libvulkan1:armhf -y

# Download DXVK.
wget https://github.com/doitsujin/dxvk/releases/download/v2.3.1/dxvk-2.3.1.tar.gz

# Unpack DXVK.
tar xvf dxvk-2.3.1.tar.gz

# Create an script to setup DXVK.
sudo echo '#!/bin/bash
cp /opt/dxvk-2.3.1/x32/* ~/.wine64/drive_c/windows/system32
cp /opt/dxvk-2.3.1/x64/* ~/.wine64/drive_c/windows/syswow64' > /usr/local/bin/setup_dxvk.sh
sudo chmod 755 /usr/local/bin/setup_dxvk.sh

# Create scripts to run Wine under box64.
sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/wine64 "$@"' > /usr/local/bin/wine
sudo chmod 755 /usr/local/bin/wine

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
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
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/wineboot "$@"' > /usr/local/bin/wineboot
sudo chmod 755 /usr/local/bin/wineboot

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/winecfg "$@"' > /usr/local/bin/winecfg
sudo chmod 755 /usr/local/bin/winecfg

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2
export BOX64_PATH=./:./bin/:$HOME/bin:/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=./:./lib/:$HOME/lib/:/opt/wine64/lib/wine/i386-unix/:/opt/wine64/lib/wine/i386-windows/:/opt/wine64/lib/wine/x86_64-unix/:/opt/wine64/lib/wine/x86_64-windows/:/usr/lib/box64-x86_64-linux-gnu/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:/lib/aarch64-linux-gnu/:/usr/lib/aarch64-linux-gnu/
export WINEPREFIX=~/.wine64
export WINEARCH=win64
box64 /opt/wine64/bin/wineserver "$@"' > /usr/local/bin/wineserver
sudo chmod 755 /usr/local/bin/wineserver

# Create a shortcut to the Wine File Manager on the Xfce desktop.
cd ~/Desktop

echo '[Desktop Entry]
Name=Wine64 Explorer
Exec=bash -c "wine64 explorer"
Icon=system-file-manager
Type=Application' > ~/Desktop/Wine64.desktop
chmod 755 ~/Desktop/Wine64.desktop
sudo cp ~/Desktop/Wine64.desktop /usr/share/applications/

# Setup Wine.
wine64 wineboot

# Setup DXVK.
setup_dxvk.sh
