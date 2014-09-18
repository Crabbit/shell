#!/bin/bash
#IP

#211.141.64.0/20 
#211.141.64.0\t211.141.79.255\t

mod=0
ip=0
range=0

function format
{
	
}

for ip_range in $(cat input.txt)
do
	range=$(echo $ip_range | cut -d '/' -f 2)
	ip=$(echo $ip_range | cut -d '/' -f 1)
	if [[ $range -lt 1 || $range -gt 35 ]]
	then
		echo "Ip range is not suitable."
		echo "Exit..."
		exit
	fi
	dot=$[$range/8]
	mod=$[$range%8]
	add=$[2**(8-$mod)-1]
	old_segment=$(echo $ip | cut -d '.' -f $[$dot+1])
	new_segment=$[$old_segment+$add]

	ip_seg1=$(echo $ip | cut -d '.' -f 1)
	ip_seg2=$(echo $ip | cut -d '.' -f 2)
	ip_seg3=$(echo $ip | cut -d '.' -f 3)
	ip_seg4=$(echo $ip | cut -d '.' -f 4)

	ip_2seg1=$(echo  "obase=2;$ip_seg1" | bc)
	ip_2seg1=$(($ip_2seg1|00000000))
	echo -n "$ip_2seg1."
	ip_2seg2=$(echo  "obase=2;$ip_seg2" | bc)
	ip_2seg2=$(($ip_2seg2|00000000))
	echo -n "$ip_2seg2."
	ip_2seg3=$(echo  "obase=2;$ip_seg3" | bc)
	ip_2seg3=$(($ip_2seg3|00000000))
	echo -n "$ip_2seg3."
	ip_2seg4=$(echo  "obase=2;$ip_seg4" | bc)
	ip_2seg4=$(($ip_2seg4|00000000))
	echo $ip_2seg4

done
