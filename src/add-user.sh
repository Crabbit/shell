#!/bin/bash

for i in `seq 40`
do
	useradd $i
	echo "$i:$i"| chpasswd
	echo "$i new finished"
done
