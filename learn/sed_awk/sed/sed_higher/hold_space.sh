#!/bin/bash
#
# Creat Time :Thu 21 Nov 2013 06:16:38 PM GMT
# Autoor     : lili

# 模式空间是一块活动的缓冲区，在sed编辑器执行命令时候
# 它会保存sed编辑器要校验的文本。
# 但它并不是sed编辑器保存文本的唯一空间.

# sed编辑器还利用了另外一块缓冲区域，称保持空间.
# 你可以在处理模式空间中其他行时用保持空间来零食保存一些行.

# h    将模式空间复制到保持空间
# H    将模式空间附加到保持空间
# g    将保持空间复制到模式空间
# G    将保持空间附加到模式空间
# x    交换保持空间和模式空间的内容.

cat > sed_holdspace.txt << "EOF"
This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
EOF

# 保持空间的初探
echo 保持空间的初探
sed -n '/first/{
h
p
n
p
g
p
}' sed_holdspace.txt

# 利用保持空间进行反转
echo  利用保持空间进行反转
sed -n '/first/{
h
n
p
g
p
}' sed_holdspace.txt

# 将全文反转
# 这里 1!G ，刚开始时候，保持空间为空
# 所以如果复制过去的话，会出现一行空行
# p前面的$符号表示当达到最后一行的时候，输出
echo 将全文反转
sed -n '{G ; h ; $p}' sed_holdspace.txt
echo 将全文反转1!
sed -n '{1!G ; h ; $p}' sed_holdspace.txt

rm -fr sed_holdspace.txt
