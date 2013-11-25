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
1111
1212
1313
1414
EOF

# 这是两个例子，从这个例子中可以看出
# N的作用到底是什么

# sed '{
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

#-----------------------------------------------------

sed '{
:rolling
N
11,$D
b rolling
}' rolling.txt

rm -fr rolling.txt
