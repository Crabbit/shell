#!/bin/bash
#
# Creat Time :Thu 16 Jan 2014 01:14:00 AM GMT
# Autoor     : lili

# 变量的使用
gawk '
BEGIN{
name="lili"
x=3
x=x+2
print "My name is",name
print "3+2 is",x
}
' 

script_temp=`mktemp script.XXXX`
cat > $script_temp << "EOF"
BEGIN{
print "输出第",n,"个字段"
FS="-"
}
{
	print $n
}
EOF

# 如果引用脚本的话，就通过-v参数来制定begin里面的变量
gawk -v n=3 -f $script_temp data
rm -fr $script_temp

# 数组
gawk '
BEGIN{
cellnumber["lili"] = "187xxxxxx82"
cellnumber["cici"] = "187xxxxxx61"
cellnumber["home"] = "135xxxxxx99"
print "lilis number :",cellnumber["lili"]
print "cicis number :",cellnumber["cici"]
print "homes number :",cellnumber["home"]
}
'
