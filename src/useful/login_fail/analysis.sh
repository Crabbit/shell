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

echo "User    Login ip        Status    Time"
#    "root    222.222.222.222 succes    06-29 22:22:22"

#About month-->number   July-->07

#关联数组，用来将日期数字化
declare -A Month
Month=([Jan]="01" [Feb]="02" [Mar]="03" [Apr]="04" [May]="05" [Jun]="06" [Jul]="07" [Aug]="08" [Sep]="09" [Oct]="10" [Nov]="11" [Dec]="12")


