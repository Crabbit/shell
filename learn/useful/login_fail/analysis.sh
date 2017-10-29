#!/bin/bash
#
# Creat Time :Tue 11 Mar 2014 05:03:17 AM GMT
# Autoor     : lili

# This scripts is analysis the last 3 days ssh login records, by /var/log/secure.
#
#
# target date:
# user  login_ip  status  time 
# root  123.138.72.119  succ  06-29 19:12:57

#define secure file.
#default: /var/log/secure
SEC_FILE=secure
#_HOSTNAME=$( hostname | cut -d'.' -f 1)
_HOSTNAME=$( echo "XiyouLinux.org" | cut -d'.' -f 1 )

#creat temporary file.
TEMP_FILE1=$( mktemp tempfile.XXXX )
TEMP_FILE2=$( mktemp tempfile.XXXX )
TEMP_FILE3=$( mktemp tempfile.XXXX )
TEMP_FILE_sec=$( mktemp tempfile.XXXX )

echo "User    Login ip        Status    Time"
#    "root    222.222.222.222 succes    06-29 22:22:22"

#About month-->number   July-->07
declare -A Month
Month=([Jan]="01" [Feb]="02" [Mar]="03" [Apr]="04" [May]="05" [Jun]="06" [Jul]="07" [Aug]="08" [Sep]="09" [Oct]="10" [Nov]="11" [Dec]="12")

grep -w "failure" $SEC_FILE | grep -w "sshd" > $TEMP_FILE_sec

#echo ${Month[$(echo "Feb")]}

#split time
cat $TEMP_FILE_sec | gawk -F" $_HOSTNAME" '{ print $1 }' > $TEMP_FILE1

#split month
for Mon in $( cat $TEMP_FILE1 | cut -d' ' -f 1 )
do
	echo ${Month[$Mon]} >> $TEMP_FILE2
done

#merge month-day-time
gawk -F" " 'NR==FNR{a[FNR]=$0;next}{print a[FNR]"-"$2"  "$3}' $TEMP_FILE2 $TEMP_FILE1 > $TEMP_FILE3

#split ip
gawk -F"rhost=" '{print $2}' $TEMP_FILE_sec | cut -d' ' -f 1 > $TEMP_FILE1

paste $TEMP_FILE1 $TEMP_FILE3 > $TEMP_FILE2
#split user
gawk -F" user=" '{print $2}' $TEMP_FILE_sec > $TEMP_FILE1

paste $TEMP_FILE1 $TEMP_FILE2 > $TEMP_FILE3
cat $TEMP_FILE3

rm -fr $TEMP_FILE1
rm -fr $TEMP_FILE2
rm -fr $TEMP_FILE2
rm -fr $TEMP_FILE3
rm -fr $TEMP_FILE_sec
