#!/bin/bash
#
# Creat Time :Thu 21 Nov 2013 12:37:29 AM GMT
# Autoor     : lili

cat > file_n.txt << "EOF"
This is the first line.

this is the third line.

this is the fifth line.

aaaa bbbb cccc dddd
1111 2222 3333 4444
AAAA BBBB CCCC DDDD
EOF

#----------------------------------------------------------
# 这样将会删除所有空行
echo "_____________sed '/^$/d' file_n.txt"
sed '/^$/d' file_n.txt

# n 命令.首先找到文本模式匹配
# 然后一旦找到了该行，n命令会将sed编辑器移动到文本的下一行
# 注意是: 移动
# 这个例子中，那是个空行
# sed编辑器会继续执行命令列表，使用d命令来删除空白行.
# 执行完脚本后，会从数据流中读取下一行文本并开始从命令脚本顶部执行命令.
# 之后，无法匹配 first行，所以不会再执行了.
echo "_____________sed '/first/{n ; d}' file_n.txt"
sed '/first/{n ; d}' file_n.txt

# N 命令. 
# 大写的N命令是将数据流中的两个文本合并到同一个模式空间.
# 会将两行文本当成一样来处理.
# 小写的n命令式讲编辑器移动到文本的下一行
echo "_____________sed '/first/{N ; s/\n/  /}' file_n.txt"
sed '/first/{N ; s/\n/----/}' file_n.txt

echo "_____________sed 'N ; s/dd.11/lili/' file_n.txt"
sed 'N ; s/dd.11/lili/' file_n.txt

#----------------------------------------------------------
# 要注意一点.
# N 总在执行sed编辑器命令前将下一行文本读入到模式空间
# 当它到了最后一行文本时，没有下一行文本刻度了
# 所以N命令会叫sed编辑器停止。
# 因此如果要匹配的文本正好在数据流的最后一样上
# 命令就不会发现要匹配的数据.
echo "_____________sed 'N ; s/dd.11/li\nli/ ; s/BBBB/cici/' file_n.txt"
sed '
N
s/dd.11/li\nli/
s/BBBB/cici/
' file_n.txt

# 如果想解决这个问题，可以这样
echo "_____________sed ' s/BBBB/cici/ ; N ; s/dd.11/li\nli/ ;' file_n.txt"
sed '
s/BBBB/cici/
N
s/dd.11/li\nli/
' file_n.txt

# 也可以使用
# !  排除命令
# $代表数据流中的最后一行文本.
echo "_____________sed '/\$!N ; s/dd.11/li\nli/ ; s/BBBB/cici/' file_n.txt"
sed '
$!N
s/dd.11/li\nli/
s/BBBB/cici/
' file_n.txt

# 要注意，如果和N命令一起使用
# 并且要删除模式空间中的行，那么两行会一起删除
echo "_____________sed 'N ; /dd.11/d' file_n.txt"
sed '
N
/dd.11/d
' file_n.txt

rm -fr file_n.txt
#----------------------------------------------------------
cat > sed_N.txt << "EOF"

2This is 2nd line.
3This is 3rd line.
4This is 4th line.

EOF

# 这里是删除第一行，第一行是空白行
#  D命令会删除模式空间中的第一行
echo "___________sed '/^$/{N ; /2nd/D}'"
sed '
/^$/{N ; /2nd/D}
' sed_N.txt

# P 大写P命令只会打印模式空间中的第一行.
# 特别注意:
#     D命令有个特性，是会强制sed编辑器返回到脚本的起始处.
#     并且在同一模式空间重复执行这些命令(它不会从数据流中读取新的文本行)
echo "__________sed -n 'N ; /ne\.\n4/P/' sed_N.txt"
sed -n '
N
/ne\.\n4/P
' sed_N.txt

rm -fr sed_N.txt
