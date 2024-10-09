#!/bin/sh

PWD=`pwd`

cd /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/

tar czf $PWD/debian.tar.gz debian
