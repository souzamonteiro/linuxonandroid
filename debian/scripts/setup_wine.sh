#!/bin/sh

# Install box86 and box64.

# Add ARMHF support, "ARM hard float", a Debian port for ARM processors that have hardware floating point support.
sudo dpkg --add-architecture armhf

# Install some required tools.
sudo apt install wget gpg

# Add box86 and box64 Debian repository.
sudo wget https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list
wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg

sudo wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list
wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg

# Update apt-get packages list.
sudo apt update

# Install box86 and box64.
sudo apt install box86-android
sudo apt install box64-android

# Install Wine.

# Install Wine in `/opt` directory.
sudo cd /opt

# Download Wine.
sudo wget https://github.com/Kron4ek/Wine-Builds/releases/download/9.7/wine-9.7-amd64.tar.xz
sudo wget https://github.com/Kron4ek/Wine-Builds/releases/download/9.7/wine-9.7-x86.tar.xz

