#!/bin/bash
#
# Creat Time :Thu 14 Nov 2013 01:10:51 AM GMT
# Autoor     : lili

# 正如你看到的
# 默认情况下，只能替换每行中出现的第一行文本
sed 's/over/xxxx/' file_e_s.txt
echo _________________________

# 想替换多行文本，需要在后面使用替换标记
# like this:
# sed s/pattern/relpacement/flags

# flags:
# 数字，表明新文本将会替换第几处模式匹配的地方.
# g, 表明新文本将会替换所有已有文本出现的地方
# p, 表明原有的行的内容要打印出来.
# w file,将替换的结果写到文件中
# 
sed 's/over/xxxx/2' file_e_s.txt
echo _________________________
sed 's/over/xxxx/g' file_e_s.txt
echo _________________________
sed -n 's/over/xxxx/p' file_e_s.txt
echo _________________________
sed 's/over/xxxx/w test.txt' file_e_s.txt
echo _________________________
