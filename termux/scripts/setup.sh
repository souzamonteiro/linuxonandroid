#/bin/sh

# Upgrade system.
pkg update -y
pkg upgrade -y

# Enable access to device storage.
termux-setup-storage

# Install Vim editor.
pkg install vim -y

# Install the proot-distro script for easy management of chroot-based Linux distribution installations.
pkg install proot-distro -y

# Install X11 for Android.
pkg install x11-repo -y
pkg install termux-x11-nightly -y

# Install Xfce4.
pkg install xfce4 xfce4-goodies -y

# Install audio support.
pkg install pulseaudio -y

# Install VirGL and Angle.
pkg install angle-android virglrenderer-android -y
