#!/bin/bash
#
# Creat Time :Sat 11 Jan 2014 10:33:44 PM GMT
# Autoor     : lili

# FIELDWIDTHS 	由空格分开定义了每个数据段确切宽度的一列数字
# FS         	Input field (字段)separator
# RS        	Input date line(数据行分隔符) separator
# OFS       	Output field separator
# ORS        	Output date line separator

echo "============================================================"
# FIELDWIDTHS
# 注意，一旦设定了FIELDWIDTHS的值，就不能更改了。
# 这个脚本表示数据将按照 7个字符 6个字符 1个字符...这样来输出
echo "xxxxxxx xxxxxx x xxxxxx x xxxxxxx"
echo "============================================================"
gawk 'BEGIN{FIELDWIDTHS="7 6 1 6 1 7"} {print $1,$2,$3,$4,$5,$6}' data


echo "============================================================"
# FS  ="-"  制定输入，以 - 为数据段分隔符
# OFS =" = "当输出的时候，以 " = "作为数据段分隔符
echo "xxxxxx = xxxxxx = xxxxxx = xxxxxx"
echo "============================================================"
gawk 'BEGIN{FS="-"; OFS=" = "} {print $1,$2,$3,$4}' data


echo "============================================================"
# RS
# FS = "\n"指定数据段的分隔符为换行符，表明每一行是一个单独的字段 
# 这样每遇到一个换行符，才分割一个数据段
# RS="" 表示空白行，则作为数据行分隔符
# 本来这里只需要输出2个数据段就行了，我输出了5个，可以思考下why
# NF 当前数据行字段数,表示当前数据行有多少字段
echo "x ~ xxxxxx-xxxxxx-xxxxxx-xxxxxx ~ xxxxxx-xxxxxx-xxxxxx-xxxxxx"
echo "============================================================"
gawk 'BEGIN{FS="\n"; OFS=" ~ "; RS=""} {print NF,$1,$2,$3,$4,$5}' data

echo "============================================================"
# 利用 NF输出passwd数据段中，以 : 为分隔符的，最后一个数据段
# 通过在NF前面加 $ 符来实现
gawk '
BEGIN{
FS=":"
OFS=" ----- "
}{
print $1,$NF
}
' /etc/passwd

echo "============================================================"
# ENVIRON
# 提取当前shell的一些环境变量
gawk '
BEGIN{
print "HOME = ",ENVIRON["HOME"]
print "PATH = ",ENVIRON["PATH"]
print "PWD  = ",ENVIRON["PWD"]
}'

