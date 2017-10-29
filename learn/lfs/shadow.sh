#!/bin/bash
#sed -i 's/groups$(EXEEXT) //' src/Makefile
#find man -name Makefile -exec sed -i 's/groups\.1 //' {} \;
#sed -i -e 's/ kl//' -e 's/ zh_CN zh_TW//' man/Makefile

for i in de es fi fr id it pt_BR; do
convert-mans UTF-8 ISO-8859-1 man/${i}/*.?
done

for i in cs hu pl;do
convert-mans UTF-8 ISO-8859-2 man/${i}/*.?
done

convert-mans UTF-8 EUC-JP man/ja/*.?
convert-mans UTF-8 KOI8-R man/ru/*.?
convert-mans UTF-8 ISO-8859-9 man/tr/*.?

