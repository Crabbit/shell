#!/bin/bash
$CC="gcc -B/usr/bin/"
../gcc-4.1.2/configure --prefix=/tools --with-local-prefix=/tools --disable-nls --enable-shared --enable-languages=c
