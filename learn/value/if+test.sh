#!/bin/bash

# 关于test的一些使用
#
#
#
# 1) if结构**************************************************************
#
# example:
# if [ `command1` && $( command2 ) || `command3` ]
#     then
#         command4
#     elif ((数学表达式))
#     then
#         command5
#     elif [[ 模式匹配 ]]
#     then
#         command6
#     else
#         command6
# fi
#
#
# 2) test数值比较*******************************************************
#
# n1 -eq n2    n1 == n2
# n1 -ge n2    n1 >= n2
# n1 -gt ne    n1 >  n2
# n1 -le n2    n1 <= n2
# n1 -lt n2    n1 <  n2
# n1 -ne n2    n1 != n2
# 注意:
# test在数值上，只能用于整数的比较，不能哟你余浮点数的比较
#
#
# 3) test字符串比较****************************************************
# test(string):
# str1 =  str2
# str2 != str2
# str1 \< str2
# str1 \> str2
# -n str1      检查str1的长度是否非0
# -z str1      检查str1的长度是否为0
# 注意:
# test命令使用标准的 ASCII 顺序，根据l两个字符串第一个不同字符的 ASCII 数值排序。
# test命令中，使用数学比较符号来表示字符串比较，而用文本代码表示数值比较，
# 如果为数值比较使用了数学运算符号，shell会将他们当成字符串值。
# -n 和 -z 用来检查一个变量是否有值，空值或者未定义的变量对shell有灾难性影响
#
#
# 4) test文件比较*****************************************************
# -d file            检查file是否存在并且是一个目录
#                    当写某个文件到某个目录之前，检查一下很有必要
# -e file            检查file是否存在
#                    检查一下你将要操作的文件或者目录是否存在
# -f file            检查file是否存在并且是一个文件
#                    -f 和 -d 可以结合 -e使用
#                    先检查是否存在，再检查是目录还是文件
# -r file            检查file是否存在并可读
# -s file            检查file是否存在并非空
#                    当你要删除空文件之前可以先检查一下
#                    当你要覆盖文件时，也可一先检查一下
# -w file            检查file是否存在并可写
# -x file            检查file是否存在并可执行
# -O file            检查file是否存在并属当前用户所有
# -G file            检查file是否存在并且默认组与当前用户相同
# file1 -nt file2    检查file1是否比file2新
# file1 -ot file2    检查file1是否比file2旧
#
#
# 5)case结构
# case variabl in
# pattern 1 | pattern 2) command1;;
# pattern3) command2::
# *)default command3;;
# esac
#
#
