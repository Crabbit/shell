#!/bin/bash
#
# Creat Time :Thu 14 Nov 2013 01:10:51 AM GMT
# Autoor     : lili

# 正如你看到的
# 默认情况下，只能替换每行中出现的第一行文本
echo "_____________sed 's/over/xxxx/' file_1_2_e_s.txt"
sed 's/over/xxxx/' file_1_2_e_s.txt

# 想替换多行文本，需要在后面使用替换标记
# like this:
# sed s/pattern/relpacement/flags

# flags:
# 数字，表明新文本将会替换 第 几处模式匹配的地方.
# g, 表明新文本将会替换所有已有文本出现的地方
# p, 表明原有的行的内容要打印出来.
# w file,将替换的结果写到文件中

# flags = 2表明替换 第 2 处
# 行寻址为2，表示只修改第2 - 4行
echo "_____________sed '2,4s/over/xxxx/2' file_1_2_e_s.txt"
sed '2,4s/over/xxxx/2' file_1_2_e_s.txt

# 表示修改第2行-结尾的所有行.
# echo "_____________sed '2,$s/over/xxxx/2' file_1_2_e_s.txt"
#sed '2,$s/over/xxxx/2' file_1_2_e_s.txt

# 匹配包含111的行，然后将over替换成xxxx
# flag为9，但是没有第九处，将无法完成替换
echo "_____________sed '/111/s/over/xxxx/9' file_1_2_e_s.txt"
sed '/111/s/over/xxxx/9' file_1_2_e_s.txt

# 同理，如果文本中包含555，则将over 替换为 xxxx
echo "_____________sed '/555/s/over/xxxx/g' file_1_2_e_s.txt"
sed '/555/s/over/xxxx/g' file_1_2_e_s.txt

# 替换所有文本出现的地方
echo "_____________sed 's@over@xxxx@g' file_1_2_e_s.txt"
sed 's@over@xxxx@g' file_1_2_e_s.txt

# -n选项会禁止sed编辑器的输出
# 结合p选项，只会输出那一行
echo "_____________sed -n 's/over/xxxx/p' file_1_2_e_s.txt"
sed -n 's/over/xxxx/p' file_1_2_e_s.txt

echo "_____________sed 's/over/xxxx/w test.txt' file_1_2_e_s.txt"
sed 's/over/xxxx/w test.txt' file_1_2_e_s.txt
