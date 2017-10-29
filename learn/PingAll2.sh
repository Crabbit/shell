#!/bin/bash
# Ping all the PC in a network segment
#
#
i=1
until [ $i -eq 255 ]
do
	ping -c1 -w1 $1.$i > /dev/null
	if [ $? -eq 0 ]
	then 
		echo "The $1.$i is Online"
	else
		:
	fi
	i=$[$i+1]
done

