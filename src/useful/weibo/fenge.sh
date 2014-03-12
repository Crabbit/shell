#!/bin/bash
# 分割文件
OLD=$IFS
IFS=$'\n'
n=3
value=0

#for string in `cat tt2`
for string in $(cat tt2)
do
	value=`expr $n % 2`
	if [[ $value == 1 ]]
	then
	case  "$string" in
  *荐|还行|较差|还好) 
	n=$[$n+1]
		echo -n "$string  ";;
  *)
	n=$[$n+1]
	n=$[$n+1]
		echo -n "      "
		echo "$string";;
	esac
	fi

	if [[ $value == 0 ]]
	then
	case "$string" in
  *荐|还行|较差|还好) 
	n=$[$n+1]
	n=$[$n+1]
		echo 
		echo -n "$string  ";;
  *)
	n=$[$n+1]
		echo "$string";;
	esac
	fi
done
IFS=$OLD
