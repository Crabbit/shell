#!/bin/bash
#
# Creat Time :Sat 11 Jan 2014 10:33:44 PM GMT
# Autoor     : lili

# FIELDWIDTHS 	由空格分开定义了每个数据段确切宽度的一列数字
# FS         	Input field separator
# RS        	Input date line separator
# OFS       	Output field separator
# ORS        	Output date line separator

echo "============================================================"
# FIELDWIDTHS
# 注意，一旦设定了FIELDWIDTHS的值，就不能更改了。
echo "xxxxxxx xxxxxx x xxxxxxx"
gawk 'BEGIN{FIELDWIDTHS="7 6 1 7"} {print $1,$2,$3,$4}' data


echo "============================================================"
# FS
echo "xxxxxx = xxxxxx = xxxxxx"
gawk 'BEGIN{FS="-"; OFS=" = "} {print $1,$2,$3}' data


