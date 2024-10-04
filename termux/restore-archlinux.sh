#/bin/sh

chmod -R 777 /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/archlinux

rm -rf /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/archlinux

tar xzf archlinux.tar.gz -C /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/
