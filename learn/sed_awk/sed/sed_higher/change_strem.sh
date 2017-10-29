#!/bin/bash
#
# Creat Time :Thu 21 Nov 2013 10:42:16 PM GMT
# Autoor     : lili

cat > sed_change.txt << "EOF"
This is the header line.
This is the first data line.
This is the second data line.
This is the last line.
EOF


# b   branch   跳转命令
# [adress]b [label]
# 参数address 决定了哪些行的数据会触发跳转命令,
# label参数定义了你要跳转到的位置.
# 如果没有label参数，跳转命令会跳到脚本的结尾.

# 简单跳转
echo 简单跳转
sed '{2,3b ; s/This is/Is this/ ; s/line./test?/}' sed_change.txt

# 可以指定跳转标签，将它加到b命令后面即可.
# 标签以冒号开始，最多可以有7个字符.

# -------------------------------------------------------------
# 指定标签跳转
echo 指定标签跳转
sed '{/first/b jump1 ; s/This is the/No jump on/
:jump1
s/This is the/Jump here on/}' sed_change.txt
# 跳转命令指定如果匹配文本first出现行
# 程序应该调到标为jump1的脚本行.
# 如果跳转命令的模式没有匹配，sed编辑器会继续执行脚本中的命令.

# -------------------------------------------------------------
# 利用/模式匹配/+跳转 一直循环替换
echo 利用/模式匹配/+跳转 一直循环替换
echo "My & name & is & lili.Her & name & is & cici" | sed -n '{
:cancel
s/&//p
/&/b cancel
}'
# -------------------------------------------------------------

# t test 测试命令.
# 测试命令会基于替换命令的输出跳转到一个标签
# 而不是基于地址跳转到一个标签.
# 提供了对数据流中的文本执行基本的if-then语句的低成本方法.
# 在没有指定标签的情况下，如果测试成功，sedn会跳转到脚本的结尾.

# 使用test命令选择性替换
# 这个例子中，没有指定标签，所以如果测试成功，会跳转到结尾.
echo 使用test命令选择性替换
sed '{
s/first/xxxxx/
t
s/This/Xxxx/
}' sed_change.txt

# 第一个替换命令，会查找模式文本中的first
# 如果它匹配了行中的模式,它会替换文本.
# 而且测试命令会跳过后面的替换命令.
# 如果第一个替换命令未能匹配模式，第二个命令就会执行.
# -------------------------------------------------------------

# 用test循环替换
echo 用test循环替换
echo "My & name & is & lili.Her & name & is & cici" | sed -n '{
:cancel
s/&//p
t cancel
}'

# 一旦测试成功，sed会跳转到一个标签
# 一旦替换失败，则会执行之后的脚本
# 由于再后面就没有脚本了，所以结束

# -------------------------------------------------------------

rm -fr sed_change.txt
