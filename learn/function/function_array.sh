#!/bin/bash
#
# Creat Time :Sun 10 Nov 2013 11:48:31 PM GMT
# Autoor     : lili

newstr=( one two three four five six seven )
echo The array is : ${newstr[*]}

count=1
while [ $count -le 7 ]
do
	echo ${newstr[$count]}
	count=$[ $count + 1 ]
done

function Test_array
{
	local fun_array
	fun_array=$1
	echo "_________________________________"
	echo "The array is :$1"
	echo "The fun_array is :${fun_array[*]}"
}

gol_array=( 1,2,3,4,5 )
Test_array $gol_array
Test_array ${gol_array[*]}
#Test_array ${$gol_array}

# source the function library
. ./function_array_source.sh
echo "_________________________________"
ECHO_lili
ECHO_cici
