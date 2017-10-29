#!/bin/bash
#
# Creat Time :Mon 25 Nov 2013 01:45:38 AM GMT
# Autoor     : lili
# 滑动窗口实现显示文本最后10行

# q quit，退出命令会退出循环

cat > rolling.txt << "EOF"
1111
2222
3333
4444
5555
6666
7777
8888
9999
1010
1-1-
1212
1313
1414
EOF

# 这是两个例子，从这个例子中可以看出
# N的作用到底是什么
# 同时可以发现这里的循环到哪

# sed -n '{
# :rolling
# N
# p
# b rolling
# }' rolling.txt

# sed '{
# :rolling
# N
# b rolling
# }' rolling.txt

#----------------------------------------------------
# 再对比这个例子，能更好的理解p前面那个位置$符的意义
# $符代表数据流中的最后一行文本.

# sed -n '{
# :rolling
# N
# $p
# b rolling
# }' rolling.txt

#-----------------------------------------------------
# 注意
# 当使用N命令的时候，将文本都添加到模式空间
# 当执行到11d，匹配到第11行的时候，会将前11行都删除.
# sed '{
# :delete
# N
# 11d
# b delete
# }' rolling.txt

#-----------------------------------------------------
# # 当模式空间达到第11行的时候，输出模式空间
# sed -n '{
# :rolling
# N
# 11,$p
# b rolling
# }' rolling.txt
# 
#-----------------------------------------------------
#
sed '{
:rolling
N
11,$D
b rolling
}' rolling.txt

rm -fr rolling.txt
