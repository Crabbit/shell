#!/bin/bash
#
# Creat Time :Sun 17 Nov 2013 04:48:54 PM GMT
# Autoor     : lili

# w命令用来想文件写入行

# 文本模式，将匹配到的行内容写入sed_passwd
# 在终端下，sed会全部输出

#echo "__________sed '/root/w sed_passwd' /etc/passwd"
#sed '/root/w sed_passwd' /etc/passwd

# 这样处理后，将会输出写入的内容.
echo "__________sed -n -e '/root/p ; /root/w sed_passwd' /etc/passwd" 
sed  -n '/root/{
p
w sed_passwd
}
' /etc/passwd

# r 允许你讲一个独立文件中的数据插入到数据流中
# 注意文件顺 序！
echo "__________sed -n -e '/root/p ; /root/1r sed_passwd' /etc/passwd"
sed -n '/root/{
p
1r sed_passwd
}' /etc/passwd

# 这将在末尾添加文本.
#sed -n '/root/{
#p
#$r sed_passwd
#}' /etc/passwd
