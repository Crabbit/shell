#!/bin/bash
mkdir -pv /usr/lib/locale
localedef -i de_DE -f ISO-8859-1 de_de
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i zh_CN -f GB18030 zh_CN
localedef -i zh_CN -f UTF-8 zh_CN
localedef -i zh_TW -f BIG5 zh_TW
localedef -i zh_TW -f UTF-8 zh_TW
localedef -i zh_HK -f BIG5-HKSCS zh_HK
localedef -i zh_HK -f UTF-8 zh_HK
localedef -i zh_SG -f GBK zh_SG
localedef -i zh_SG -f UTF-8 zh_sg
localedef -i en_US -f UTF-8 en_US

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf
passwd: files
group: files
shadow: files
hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files
# End /etc/nsswitch.conf
EOF
