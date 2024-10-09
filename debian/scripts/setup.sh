#/bin/sh

# Update system.
apt update -y

# Install system.

# Install basic programs.
apt install sudo vim firefox-esr -y

# Install Xfce desktop.
apt install xfce4 xfce4-goodies dbus-x11 -y

# Install locales.
apt install locales fonts-noto-cjk -y

# Setup system.

# Setup root password.
echo "Setup root password:"
passwd

# Add some needed groups.
groupadd storage
groupadd wheel
groupadd video

# Create a regular user.
useradd -m -g users -G audio,storage,wheel,video -s /bin/bash user
echo "Setup user password:"
passwd user

# Add the new user to `/etc/sudoers`, running `visudo` and inserting the following line just after `root ALL=(ALL:ALL) ALL`:
# `user ALL=(ALL:ALL) ALL`
# To insert the line press key `[i]`, type the code and press keys `[ESC]`, `[:]`, `[w]`, `[q]` and `[ENTER]`, to save the file.

# Setup the locale, language, time zone and charset, (for example America/Bahia).
ln -sf /usr/share/zoneinfo/America/Bahia /etc/localtime

# Edit `/etc/locale.gen` to setup your charset.
# vim /etc/locale.gen
# Uncomment your charset, removing the hash character `#` from the start of the line (for example `pt_BR.UTF-8 UTF-8`). To do so, press key `[i]`, uncomment the code and press keys `[ESC]`, `[:]`, `[w]`, `[q]` and `[ENTER]`, to save the file.

# Genarate the locales and setup your language.
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
