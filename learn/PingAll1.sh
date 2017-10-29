#!/bin/bash
# Ping all the PC in a network segment
#
#
n=0
for  (( i=1; i<255; i++ ))
do
	  ping -c1 -w1 $1.$i > /dev/null
	if [ $? -eq 0 ]
	then 
		echo "The $1.$i is Online"
		n=$[$n+1]
	else
		:
	fi
done

echo "There is $n user "
