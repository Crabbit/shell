#!/bin/bash
mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld

gcc -dumpspecs | sed \
-e 's@/tools/lib/ld-linux.so.2@/lib/ld-linux.so.2@g' \
-e '\/*startfile_prefix_spec:/{n;s@.*/usr/lib/ @}' \
-e '\/*cpp:/{n;s@$@ -isystem /usr/include@}' > \
`dirname $(gcc --print-libgcc0file-name)`/specs
