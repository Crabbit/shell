#!/bin/bash
#
# Creat Time :Sun 17 Nov 2013 01:31:24 AM GMT
# Autoor     : lili

# d删除
# 不指定行寻址会删除所有行.


# 删除所有文本
echo "___________sed 'd' file_3_4_d_i_a.txt"
sed 'd' file_3_4_d_i_a.txt

# 删除第三行
echo "___________sed '3d' file_3_4_d_i_a.txt"
sed '3d' file_3_4_d_i_a.txt

# 删除第二行--结尾
echo "___________sed '2,\$d' file_3_4_d_i_a.txt"
sed '2,$d' file_3_4_d_i_a.txt

# 删除1 -- 3行
echo "___________sed '1,3d' file_3_4_d_i_a.txt"
sed '1,3d' file_3_4_d_i_a.txt

# 删除 1 , 3行
echo "___________sed -e '1d' -e '3d' file_3_4_d_i_a.txt"
sed -e '1d' -e '3d' file_3_4_d_i_a.txt

# 这里也能使用文本匹配模式来删除
# 匹配文中有1,3的，将中间的内容删除.
echo "___________sed '/1/,/3/d' file_3_4_d_i_a.txt"
sed '/1/,/3/d' file_3_4_d_i_a.txt

# 但是要注意
# 第一个模式会"打开"删除功能
# 第二个模式会"关闭"删除功能
# 如果指定了一个从未在文本中出现的停止模式
# 会将整个数据流都删掉
echo "__________sed '/1/,/7/d' file_3_4_d_i_a.txt"
sed '/1/,/7/d' file_3_4_d_i_a.txt
