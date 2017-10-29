#!/bin/bash
n=0;
for  (( i=1; i<=40; i++ ))
do
	useradd $i
	echo "$i:$i" | chpasswd 
done
