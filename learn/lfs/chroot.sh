#!/bin/bash
chroot /mnt/lfs /usr/bin/env -i HOME=/root TERM=linux PS1='\u:\w$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin /bin/bash --login +h

mount -v --bind /dev /mnt/lfs/dev
mount -vt devpts devpts /mnt/lfs/dev/pts
mount -vt tmpfs shm /mnt/lfs/dev/shm
mount -vt proc proc /mnt/lfs/proc
mount -vt sysfs sysfs /mnt/lfs/sys
