#!/bin/bash

exec_log_file="exec.log"
touch $exec_log_file


cat parser.log | grep "url=" > $exec_log_file


#===================================================================
#2)
echo "Processing url per minute:"
cut -c 15-19 $exec_log_file | uniq -c 

echo -n "The total number of processing url:"
cat $exec_log_file | wc -l 


#===================================================================
#3)
echo
echo
echo "Processing url success(ext_ret=4) per minute:"
grep "ext_ret=4" $exec_log_file | cut -c 15-19 | uniq -c


#===================================================================
#4)
#
function get_info()
{
temp_tm_log="temp_tm.log"
sed -n "s/.*$1=\(.*\) $2.*/\1/p" $exec_log_file > $temp_tm_log
echo -n "$1 max value:"
sort -nr $temp_tm_log | head -1

echo -n "$1 min value:"
sort -n $temp_tm_log | head -1

sum=0
sum=$(cat $temp_tm_log | awk '{sum+=$1} END{print sum}')
amount=$(cat $temp_tm_log | wc -l)
echo -n "$1 ave value:"
echo $[$sum/$amount]
echo
echo
}

get_info get_tm PAGE
get_info css_tm css_res
get_info data_path_tm entity
get_info entity_tm antispam
get_info antispam_tm spaminfo
get_info ext_tm ext_sv


#exec 3< $exec_log_file
#content="initalization"
#count=1

#while [ -n "$content" ]
#do
	#read content <&3
	#echo $content
#done

rm -fr $exec_log_file
rm -fr $temp_tm_log
#exec 3<&-
