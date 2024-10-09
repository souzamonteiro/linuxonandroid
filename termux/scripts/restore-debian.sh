#/bin/sh

chmod -R 777 /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian

rm -rf /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian

tar xzf debian.tar.gz -C /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/
