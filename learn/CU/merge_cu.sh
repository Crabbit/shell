#!/bin/bash
#
# Creat Time :Thu 28 Nov 2013 01:31:15 AM GMT
# Autoor     : lili
# 合并
# 
#   xxxxxxxxxxxxxxx
# xxxxxxxxxx
# xxxxxxxxxxxxx
#   xxxxxxxxxxxxxxx
# xxxxxxxxxxxxxxxxx
# xxxxxx
#   xxxxxxxxxxxxxxx
# xxxxxxxxxxxxx
# xxxxxxxxxx
# 
# 为
#   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#
cat > CU.txt << "EOF"
  xxxxxxxxxxxxxxx
xxxxxxxxxx
xxxxxxxxxxxxx
  xxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxx
xxxx
xx
  xxxxxxxxxxxxxxx
xxxxxxxxxxxxx
xxxxxxxxxx
EOF

sed '{
:merge
N
s/\n//
$!b merge
s/  /\n/g
}' CU.txt

#rm -fr CU.txt
