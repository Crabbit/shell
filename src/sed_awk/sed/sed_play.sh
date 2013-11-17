#!/bin/bash
#
# Creat Time :Sun 17 Nov 2013 05:23:21 AM GMT
# Autoor     : lili

# sed几种输出的方法
# 挺好玩的

# 这是grep的实现
echo "__________sed -n '/root/p' /etc/passwd"
sed -n '/root/p' /etc/passwd

# 这可以指定输出行内容
echo "__________sed -n '1,4p' /etc/passwd"
sed -n '1,4p' /etc/passwd

# 先输出，然后替换
echo "__________sed -n -e'/root/p ; s/root/lili/p' "
sed -n '/root/{
p
s/root/lili/p
}' /etc/passwd

echo "__________sed"
sed '=' /etc/passwd
