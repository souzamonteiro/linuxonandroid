#!/bin/sh

# Install box86 and box64.

# Add ARMHF support, "ARM hard float", a Debian port for ARM processors that have hardware floating point support.
sudo dpkg --add-architecture armhf -y

# Install some required tools.
sudo apt install wget gpg -y

# Add box86 and box64 Debian repository.
sudo wget https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list
wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg

sudo wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list
wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg

# Update apt-get packages list.
sudo apt update -y

# Install box86 and box64.
sudo apt install box86-android -y
sudo apt install box64-android -y

# Install Wine.

# Install Wine in `/opt` directory.
cd /opt

# Download Wine.
sudo wget https://github.com/Kron4ek/Wine-Builds/releases/download/9.7/wine-9.7-amd64.tar.xz
sudo wget https://github.com/Kron4ek/Wine-Builds/releases/download/9.7/wine-9.7-x86.tar.xz

# Unpack Wine.
sudo tar xvf wine-9.7-amd64.tar.xz
sudo tar xvf wine-9.7-x86.tar.xz

sudo mv wine-9.7-amd64 wine64
sudo mv wine-9.7-x86 wine

# Install DXVK a Vulkan-based translation layer for Direct3D 9/10/11.

# Install DXVK dependencies.
sudo apt install mesa-vulkan-drivers mesa-vulkan-drivers:armhf libvulkan1 libvulkan1:armhf -y

# Download DXVK.
wget https://github.com/doitsujin/dxvk/releases/download/v2.3.1/dxvk-2.3.1.tar.gz

# Unpack DXVK.
tar xvf dxvk-2.3.1.tar.gz

# Create an script to setup DXVK.

sudo echo '#!/bin/bash
cp /opt/dxvk-2.3.1/x32/* ~/.wine32/drive_c/windows/system32
cp /opt/dxvk-2.3.1/x32/* ~/.wine64/drive_c/windows/system32
cp /opt/dxvk-2.3.1/x64/* ~/.wine64/drive_c/windows/syswow64' > /usr/local/bin/setup_dxvk.sh
sudo chmod 755 /usr/local/bin/setup_dxvk.sh

# Create scripts to run Wine under box86 and box64.

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2

export BOX86_PATH=/opt/wine/bin/
export BOX86_LD_LIBRARY_PATH=/opt/wine/lib/wine/i386-unix/:/lib/i386-linux-gnu/:/lib/aarch64-linux-gnu/:/lib/arm-linux-gnueabihf/:/usr/lib/aarch64-linux-gnu/:/usr/lib/arm-linux-gnueabihf/:/usr/lib/i386-linux-gnu/
export WINEPREFIX=~/.wine32

box86 /opt/wine/bin/wine "$@"' > /usr/local/bin/wine
sudo chmod 755 /usr/local/bin/wine

sudo echo '#!/bin/bash
export DISPLAY=:0
export GALLIUM_DRIVER=virpipe
export MESA_GL_VERSION_OVERRIDE=4.6COMPAT
export MESA_GLES_VERSION_OVERRIDE=3.2

export BOX64_PATH=/opt/wine64/bin/
export BOX64_LD_LIBRARY_PATH=/opt/wine64/lib/i386-unix/:/opt/wine64/lib/wine/x86_64-unix/:/lib/i386-linux-gnu/:/lib/x86_64-linux-gnu:/lib/aarch64-linux-gnu/:/lib/arm-linux-gnueabihf/:/usr/lib/aarch64-linux-gnu/:/usr/lib/arm-linux-gnueabihf/:/usr/lib/i386-linux-gnu/:/usr/lib/x86_64-linux-gnu/
export WINEPREFIX=~/.wine64

box64 /opt/wine64/bin/wine64 "$@"' > /usr/local/bin/wine64
sudo chmod 755 /usr/local/bin/wine64

# Create shortcuts to the Wine File Manager on the Xfce desktop.
cd ~/Desktop

echo '[Desktop Entry]
Name=Wine32 Explorer
Exec=bash -c "wine explorer"
Icon=system-file-manager
Type=Application' > ~/Desktop/Wine32.desktop
chmod 755 ~/Desktop/Wine32.desktop
sudo cp ~/Desktop/Wine32.desktop /usr/share/applications/

echo '[Desktop Entry]
Name=Wine64 Explorer
Exec=bash -c "wine64 explorer"
Icon=system-file-manager
Type=Application' > ~/Desktop/Wine64.desktop
chmod 755 ~/Desktop/Wine64.desktop
sudo cp ~/Desktop/Wine64.desktop /usr/share/applications/

# Setup Wine.
wine wineboot
wine64 wineboot

# Setup DXVK.
setup_dxvk.sh

# Install Winetricks.
cd /opt

# Download Winetricks.
sudo wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod 755 winetricks
mv winetricks /usr/local/bin/

# Create scripts to run Winetricks.
sudo echo '#!/bin/bash
export BOX86_NOBANNER=1 WINE=wine WINEPREFIX=~/.wine32 WINESERVER=/opt/wine/bin/wineserver
wine '"/usr/local/bin/winetricks "'"$@"' > /usr/local/bin/winetricks32
chmod +x /usr/local/bin/winetricks32

sudo echo '#!/bin/bash
export BOX64_NOBANNER=1 WINE=wine64 WINEPREFIX=~/.wine64 WINESERVER=/opt/wine64/bin/wineserver
wine64 '"/usr/local/bin/winetricks "'"$@"' > /usr/local/bin/winetricks64
chmod +x /usr/local/bin/winetricks64

