#!/bin/bash
#
# Creat Time :Sun 24 Nov 2013 11:56:43 PM GMT
# Autoor     : lili

# 文本的逆置
# 从命令行中传递参数.
sed -n '{
1!G
h
$p
}' $1


# 添加空行
sed 'G' /etc/passwd

# 添加行号
sed '=' /etc/passwd | sed 'N ; s/\n/ /'
