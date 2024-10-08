# Linux on Android
Linux distribution for Android.

## Upgrade Termux
Upgrade system:
```
pkg update -y
pkg upgrade -y
```

## Setup device storage access
Enable access to device storage:
```
termux-setup-storage
```

# Install Vim
Install Vim editor:
```
pkg install vim -y
```

## Install PRoot Distro
Install the proot-distro script for easy management of chroot-based Linux distribution installations:
```
pkg install proot-distro -y
```

## Install Termux-X11
Install X11 for Android:
```
pkg install x11-repo -y
pkg install termux-x11-nightly -y
```

## Install audio support
Install PulseAudio:
```
pkg install pulseaudio -y
```

## Setup hardware acceleration
Install VirGL and Angle:
```
pkg update -y
pkg upgrade -y

pkg install angle-android virglrenderer-android
```

## Install Debian
Install Debian Linux:
```
proot-distro install debian
```

## Login
Do the first login:
```
proot-distro login debian --user root --shared-tmp
```

