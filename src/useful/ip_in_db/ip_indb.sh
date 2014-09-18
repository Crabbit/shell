#!/bin/bash
#IP

#211.141.64.0/20 
#211.141.64.0\t211.141.79.255\t

mod=0
ip=0
range=0

input_filename="$1"
output_filename="out2.txt"
touch $output_filename

tempfile_swap=$( mktemp tempfile.XXX )
#sed -n 's/\r//p' $input_filename > $tempfile_swap
cat $input_filename > $tempfile_swap

for ip_range in $(cat $tempfile_swap)
do
	range=$(echo $ip_range | cut -d '/' -f 2)
	ip=$(echo $ip_range | cut -d '/' -f 1)
	if [[ $range -lt 1 || $range -gt 35 ]]
	then
		echo "Ip range is not suitable."
		echo "Exit..."
		exit
	fi
	declare -A ip_seg
	ip_seg=([1]=$(echo $ip | cut -d '.' -f 1) [2]=$(echo $ip | cut -d '.' -f 2) [3]=$(echo $ip | cut -d '.' -f 3) [4]=$(echo $ip | cut -d '.' -f 4))

	dot=$[$range/8]
	mod=$[$range%8]
	add=$[2**(8-$mod)-1]
	old_segment=$(echo $ip | cut -d '.' -f $[$dot+1])
	new_segment=$[$old_segment+$add]

#print
	number=1
	while [[ number -le 4 ]]
	do
		if [[ $number -eq 1 ]];then
			echo -ne "$ip\t" >> $output_filename
		else
			echo -n . >> $output_filename
		fi
		
		if [[ $number -eq $(($dot+1)) ]];then
			echo -n "$new_segment" >> $output_filename
		else 
			if [[ $number -gt $(($dot+1)) ]];then
				echo -n "255" >> $output_filename
			else
				echo -n "${ip_seg[$number]}" >> $output_filename
			fi
		fi
		number=$[$number+1]
	done
	echo -ne "\t\r\n">> $output_filename
done

rm -fr $tempfile_swap
