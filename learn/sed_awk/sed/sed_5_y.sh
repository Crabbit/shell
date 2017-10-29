#!/bin/bash
#
# Creat Time :Sun 17 Nov 2013 04:49:07 AM GMT
# Autoor     : lili

# y  转换命令
# 是sed唯一可以处理单个字符的命令.
# [address]y/inchars/outchars
# inchars 模式中指定的字符每个实例
# 都会被替换成outchars模式中相同位置的那个字符

# 这是一个全局命令，将会替换文本行中找到的所有指定字符
# 而不会考虑他们出现的位置.

sed 'y/abc1/ABC-/' file_5_y.txt
