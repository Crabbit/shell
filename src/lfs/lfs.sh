#!/bin/bash
export LFS=/mnt/lfs

groupadd lili
useradd -s /bin/bash -g lili -m -k /dev/null lili
echo lililili | passwd --stdin lili

mkdir -pv $LFS/tools
mkdir -pv $LFS/sources
mkdir -pv $LFS/sources/gcc-build{1,2}
mkdir -pv $LFS/sources/binutils-build{1,2}
mkdir -pv $LFS/sources/glibc-build
ln -sv $LFS/tools /
chown -v lili.lili $LFS/tools
chown -Rv lili.lili $LFS/sources

HOME=/home/lili/
echo "exec env -i HOME=$HOME TERM=$TERM PS1='\u @ \h \W #' /bin/bash" > $HOME/.bash_profile
echo "set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL PATH" > $HOME/.bashrc
