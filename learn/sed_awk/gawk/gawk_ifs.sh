#!/bin/bash
#
# Creat Time :Wed 13 Nov 2013 04:10:38 AM GMT
# Autoor     : lili

gawk 'BEGIN {print "This is my first gawk!"}'

# 默认分隔符为空格、制表符，输出第一个数据段
gawk '{print $1}' gawk_ifs.txt
echo ________________________________

# 指定分隔符为: 输出第一个数据段
gawk -F: '{print $1}' ./gawk_ifs.txt
echo ________________________________

# 指定分隔符为空格，输出第一个数据段
gawk -F' ' '{print $1}' ./gawk_ifs.txt
echo ________________________________

#将第4个数据替换成Test,并且输出整个文本.
gawk -F' ' '{$4="Test"; print $0}' ./gawk_ifs.txt
echo ________________________________

#指定从gawk 脚本中读取规则.
gawk -f gawk_ifs.script ./gawk_ifs.txt
echo ________________________________


gawk 'END {print "End of this gawk."}' ./gawk_ifs.txt
