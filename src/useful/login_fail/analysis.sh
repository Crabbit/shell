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
TEMP_FILE_sec=$( mktemp tempfile.XXXX )

echo "User    Login ip        Status    Time"
#    "root    222.222.222.222 succes    06-29 22:22:22"

#About month-->number   July-->07
declare -A Month
Month=([Jan]="01" [Feb]="02" [Mar]="03" [Apr]="04" [May]="05" [Jun]="06" [Jul]="07" [Aug]="08" [Sep]="09" [Oct]="10" [Nov]="11" [Dec]="12")

grep -w "failure" $SEC_FILE > $TEMP_FILE_sec

#echo ${Month[$(echo "Feb")]}

#split time
grep -w "sshd" $TEMP_FILE_sec | gawk -F" $_HOSTNAME" '{ print $1 }' > $TEMP_FILE1

grep -w "sshd" $TEMP_FILE_sec | gawk -F" $_HOSTNAME" '{ print $1 }' | cut -d' ' -f 1 > $TEMP_FILE2


#rm -fr $TEMP_FILE1
#rm -fr $TEMP_FILE2
rm -fr $TEMP_FILE_sec
