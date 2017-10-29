#!/bin/bash
#
# Creat Time :Mon 10 Mar 2014 07:08:35 PM GMT
# Autoor     : lili


OLD_IFS=$IFS

IFS=$'\n'

#定义id，用来表示学号，并初始化
#score_id 给score.txt文件使用
#info_id 给info.txt文件使用
info_id='0000'
score_id='0000'
score_line="null"

#定义一个标记，用来指示当前数据列
flag=1
#统计成绩
for score_line in $(cat score.txt)
do
	IFS=" "
#输出学号
	score_id=$( echo $score_line | cut -d " " -f 1 )
	echo $score_id

	#让IFS恢复为空行
	IFS=$'\n'
done

IFS=$OLD_IFS

#合并了两个文件
awk -F"    " 'NR==FNR{a[$1]=$0;next}{print a[$1]"    "$2"    "$3}' info.txt score.txt
