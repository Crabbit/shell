#!/bin/bash
#
# Creat Time :Tue 19 Nov 2013 04:15:13 AM GMT
# Autoor     : lili

# 实现显示各个path目录

# -------------------------------------------------
echo "__________sed__________"
for pathname in $(echo $PATH | sed 's/:/ /g')
do
	echo $pathname
done

# -------------------------------------------------
echo "__________cut__________"
count=1
while [ $pathname ]
do
	pathname=`echo $PATH | cut -d : -f $count`
	if [ $pathname ]
	then
		echo $pathname
	else
		break
	fi
	count=$[ $count + 1 ]
done
# -------------------------------------------------
echo "__________IFS__________"
OLD_IFS=$IFS
IFS=:
for pathname in $PATH
do
	echo $pathname
done
IFS=$OLD_IFS

# -------------------------------------------------
echo "_______awk__V1_________"
count=1
pathname=`echo $PATH | awk '{gsub(/:/," ")}{print $0}'`
for pathname in $pathname
do
	echo $pathname
done
# -------------------------------------------------
echo "_______awk__V2_________"
	echo $PATH | awk '{
	n = split($0,pathname,":");
	for( i = 1; i<=n; i++ )
		print("Dir : "pathname[i]);
	}'
# -------------------------------------------------
echo "_________xargs_________"
# -t 表示表示使用一个详细模式
# 显示要运行的命令。调试的时候很有用
# -i 表示告诉xargs用每项的名称替换{}
# echo $PATH | xargs -t -d : -i echo Dir : {} | grep -v ^$ 
echo $PATH | xargs -d : -i echo Dir : {} | grep -v ^$ 

