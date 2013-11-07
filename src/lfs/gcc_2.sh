#!/bin/bash
#sed -i 's/install_to_$(INSTALL_DEST) //' ../gcc-4.1.2/libiberty/Makefile.in
MAKE_PATH=/mnt/lfs/sources/gcc-4.1.2/gcc
cp -v $MAKE_PATH/Makefile.in{,.orig}
sed 's@\./fixinc\.sh@-c true@' $MAKE_PATH/Makefile.in.orig > $MAKE_PATH/Makefile.in
cp -v $MAKE_PATH/Makefile.in{,.tmp}
sed 's/^XCFLAGS =$/& -fomit-frame-pointer/' $MAKE_PATH/Makefile.in.tmp > $MAKE_PATH/Makefile.in
patch -Np1 -i /lfs-sources/gcc-4.1.2-specs-1.patch
cd /mnt/lfs/sources/gcc-build2/
../gcc-4.1.2/configure --prefix=/tools --with-local-prefix=/tools --enable-clocale=gnu --enable-shared --enable-threads=posix --enable-__cxa_atexit --enable-languages=c,c++ --disable-libstdcxx-pch
