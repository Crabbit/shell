#!/bin/bash
#IP

#211.141.64.0/20 
#211.141.64.0\t211.141.79.255\t

mod=0
ip=0
range=0

input_filename="$1"
output_filename="out1.txt"
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

	echo -ne "$ip\t" >> $output_filename
	new_ip=$(ipcalc -b $ip_range| cut -d '=' -f 2 )
	echo -ne "$new_ip\t\r\n" >> $output_filename

done

rm -fr $tempfile_swap
