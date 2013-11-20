#!/bin/bash
#
# Creat Time :Tue 19 Nov 2013 04:15:13 AM GMT
# Autoor     : lili

# 实现显示各个path目录

echo "__________sed__________"
for pathname in $(echo $PATH | sed 's/:/ /g')
do
	echo $pathname
done
echo

# -------------------------------------------------
echo "__________IFS__________"
OLD_IFS=$IFS
IFS=:
for pathname in $PATH
do
	echo $pathname
done
IFS=$OLD_IFS
echo

# -------------------------------------------------
echo "_______awk__V1_________"
count=1
pathname="test"
pathname=`echo $PATH | awk -F: '{print $count}'`
echo $pathname
while [ $pathname -z 0 ]
do
	pathname=`echo $PATH | awk -F: '{print $count}'`
	echo $pathname
done
