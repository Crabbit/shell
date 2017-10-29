#!/bin/bash
#
# Creat Time :Mon 18 Nov 2013 01:46:45 AM GMT
# Autoor     : lili

# caret character
# 脱字符  ^
# 定义从数据流中文本行的行首开始的模式

# 这是过滤包含 root 的问本行
echo "___________sed -n '/root/p' /etc/passwd"
sed -n '/root/p' /etc/passwd
echo

# 这是输出以 root 为开头的文本行
echo "___________sed -n '/^root/p' /etc/passwd"
sed -n '/^root/p' /etc/passwd
echo

# 输出以 bash 为结尾的文本行
echo "___________sed -n '/bash$/p' /etc/passwd"
sed -n '/bash$/p' /etc/passwd
echo

#新建一个有内容的临时文件
tempfile=`mktemp sed_file.XXXX`
cat > $tempfile << "EOF"
aabbccdd
11223344

X11223344X
AABBCCDD
55667788
EOF
echo "__________cat $tempfile"
cat $tempfile
# 组合锚点输出 行内容为 11223344 的文本行
echo "__________sed -n '/^11223344$/' $tempfile"
sed -n '/^11223344$/p' $tempfile

# 组合锚点中间不加任何文本，可以过滤出空白行
echo "__________sed -n '/^$/p' $tempfile"
sed -n '/^$/p' $tempfile
# 通过 = 来打印为空白行的行号，
echo "__________sed -n '/^$/=' $tempfile"
# grep -n ^$
sed -n '/^$/=' $tempfile
# 删除空白行
echo "__________sed -n '/^$/d' $tempfile"
sed '/^$/d' $tempfile

rm -fr $tempfile
