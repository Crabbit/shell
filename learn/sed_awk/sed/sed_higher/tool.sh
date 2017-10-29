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

# 每行的反转(这是CU上给出的)
# \(.\)表示选取任意一个单个字符
# 匹配中将文本分成了2段: 第一个字符+一直到换行符前面的所有字符
# 换成  先前行+行首字符+第二个字符之后一直到换行符前面的字符
# 例如  123\n
# 第一次替换为: 123\n23\n1
sed '
/\n/!G
s/\(\)\(.*\n\)/&\2\1/
//D
s/.//'

# 在每一行前面添加4个空格
sed 's/^/    /' /etc/passwd

# 添加空行
sed 'G' /etc/passwd

# 添加2行空行
sed 'G;G' /etc/passwd

# 在文本匹配后添加空行
sed '/root/{G}' /etc/passwd

# 在文本匹配前添加空行
sed '/root/{x;p;x;}' /etc/passwd

# 在文本匹配前后各添加一行
sed '/root/{x;p;x;G}' /etc/passwd

# 添加行号
sed '=' /etc/passwd | sed 'N ; s/\n/ /'

# 统计文件行数
wc -n '$=' /etc/passwd

# 将文本对其到80列
# 这里&符号代表这行内容.
# ^$就限制了文本长度
# 第一次循环的时候，将会在前面补上第一个空格，以此类推
sed '{
:a
s/^.\{1,79\}$/ &/
t a
}' /etc/passwd

# 使所有文本处于80行的中央
sed '{
:a
s/^.\{1,79\}$/ & /
t a
}' /etc/passwd
