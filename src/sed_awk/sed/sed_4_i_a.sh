#!/bin/bash
#
# Creat Time :Sun 17 Nov 2013 03:00:10 AM GMT
# Autoor     : lili

# i 插入
# 会将文本插入在数据流的前面
# [address]command\
# command : a追加  i插入

echo "______________echo "Test 11111111" | sed 'i\Test 22222222'"
echo "Test 11111111" | sed 'i\Test 22222222'

# a 追加
# 会将文本追加到数据流的后面
echo "______________echo "Test 11111111" | sed 'a\Test 2222222'"
echo "Test 11111111" | sed 'a\Test 2222222'

echo "______________sed '3i\xxxxxxxxxxxxxxxxxxxxxxxxx'"
sed '3i\
xxxxxxxxxxxxxxxxxxxxxxxxxx
' file_3_4_d_i_a.txt

echo "______________sed '\$a\xxxxxxxxxxxxxxxxxxxxxxxxx'"
sed '$a\
xxxxxxxxxxxxxxxxxxxxxxxxxx
' file_3_4_d_i_a.txt

# c 更改行内容
echo "_____________sed '3c\xxxxxxxxxxxxxxxxxxx' file_3_4_d_i_a.txt"
sed '3c\xxxxxxxxxxxxxxxxxxx' file_3_4_d_i_a.txt

# 文本模式来匹配更改内容
echo "_____________sed '/22/c\xxxxxxxxxxxxxxxxxxxxx' file_3_4_d_i_a.txt"
sed '/22/c\xxxxxxxxxxxxxxxxxxxxx' file_3_4_d_i_a.txt
