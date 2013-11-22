#!/bin/bash
#
# Creat Time :Fri 22 Nov 2013 02:00:56 AM GMT
# Autoor     : lili

cat > sed_modelsubstitute.txt << "EOF"
The cat sleeps in the hat.
The lili's hat is cool.
The lili's cat is beauty.
The lili's phone is 18710102020
The cici's phone is 18730304040
EOF

# 想把含有at的单词两边加上!
echo "__________sed 's/.at/!.at!/g' sed_modelsubstitute.txt"
sed 's/.at/!.at!/g' sed_modelsubstitute.txt
# 可以看出不符合要求

# &符号用来代表替换命令中的匹配模式.
# & 会提取匹配替换命令中指定模式的整个字符串
echo "__________sed 's/.at/!&!/g' sed_modelsubstitute.txt"
sed 's/.at/!&!/g' sed_modelsubstitute.txt

#----------------------------------------------------------

# 但是，正如上面所说，&符号会代表整个字符串
# sed编辑器用元口号来定义替换模式的子字符串
# 给第一个模块分配字符\1,给第二个模块分配字符\2

echo "__________sed 's/s\ \(.at\)/s\ !\1!/g' sed_modelsubstitute.txt"
sed 's/lili\x27s\ \(.at\)/Lili\x27s\ !\1!/g' sed_modelsubstitute.txt

# 转换号码
echo 转换号码
sed '{
:phone
s/\([0-9]\{3\}\)\([0-9]\{4\}\)\([0-9]\{4\}\)/\1\-\2\-\3/
t phone
}' sed_modelsubstitute.txt

#sed '{
#s/\([0-9]\{3\}\)\([0-9]\{4\}\)\([0-9]\{4\}\)/\1\-\2\-\3/
#}' sed_modelsubstitute.txt

rm -fr sed_modelsubstitute.txt
