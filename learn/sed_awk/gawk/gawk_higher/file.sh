#!/bin/bash
#
# Creat Time :Wed 15 Jan 2014 11:04:22 PM GMT
# Autoor     : lili

# 用来输出文件的一些信息
echo ======================================================
# ARGC  当前gawk处理行后面参数个数
# ARGV  gawk处理参数数组
# NF    当前数据行的字段总数

# FNR   当前处理的数据文件中的数据行数
# NR    当前已经处理的数据行数
# 如果只是用一个数据文件作为输入，那么FNR 与 NR将相等.

gawk '
BEGIN{
print "There is total  ",ARGC
print "Options 0 :",ARGV[0]
print "Options 1 :",ARGV[1]
print "Options 2 :",ARGV[2]
print "Options 3 :",ARGV[3]
print "Options 4 :",ARGV[4]
}' a b c d

echo ======================================================
gawk '
BEGIN{
FS=":"
print "The file is :",ARGV[1]
}
{print "Line ",FNR,"NR is",NR,$1,"---- ",$NF
}' /etc/passwd data
