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
# -- get_tm information --
#
get_tm_log="get_tm.log"
sed -n 's/.*get_tm=\(.*\) PAGE.*/\1/p' $exec_log_file > $get_tm_log
echo -n "get_tm max value:"
sort -nr $get_tm_log | head -1

echo -n "get_tm min value:"
sort -n $get_tm_log | head -1

sum=0
sum=$(cat $get_tm_log | awk '{sum+=$1} END{print sum}')
amount=$(cat $get_tm_log | wc -l)
echo -n "get_tm ave value:"
echo $[$sum/$amount]
echo
echo


# -- css_tm information --
#
css_tm_log="css_tm.log"
sed -n 's/.*css_tm=\(.*\) css_res.*/\1/p' $exec_log_file > $css_tm_log
echo -n "css_tm max value:"
sort -nr $css_tm_log | head -1

echo -n "css_tm min value:"
sort -n $css_tm_log | head -1

sum=0
sum=$(cat $css_tm_log | awk '{sum+=$1} END{print sum}')
amount=$(cat $css_tm_log | wc -l)
echo -n "css_tm ave value:"
echo $[$sum/$amount]
echo
echo


# -- data_path_tm information --
#
data_path_tm_log="data_path_tm.log"
sed -n 's/.*data_path_tm=\(.*\) entity.*/\1/p' $exec_log_file > $data_path_tm_log
echo -n "data_path_tm max value:"
sort -nr $data_path_tm_log | head -1

echo -n "data_path_tm min value:"
sort -n $data_path_tm_log | head -1

sum=0
sum=$(cat $data_path_tm_log | awk '{sum+=$1} END{print sum}')
amount=$(cat $data_path_tm_log | wc -l)
echo -n "data_path_tm ave value:"
echo $[$sum/$amount]
echo
echo


# -- entity_tm information --
#
entity_tm_log="entity_tm.log"
sed -n 's/.*entity_tm=\(.*\) antispam.*/\1/p' $exec_log_file > $entity_tm_log
echo -n "entity_tm max value:"
sort -nr $entity_tm_log | head -1

echo -n "entity_tm min value:"
sort -n $entity_tm_log | head -1

sum=0
sum=$(cat $entity_tm_log | awk '{sum+=$1} END{print sum}')
amount=$(cat $entity_tm_log | wc -l)
echo -n "entity_tm ave value:"
echo $[$sum/$amount]
echo
echo


# -- antispam_tm information --
#
antispam_tm_log="antispam_tm.log"
sed -n 's/.*antispam_tm=\(.*\) spaminfo.*/\1/p' $exec_log_file > $antispam_tm_log
echo -n "antispam_tm max value:"
sort -nr $antispam_tm_log | head -1

echo -n "antispam_tm min value:"
sort -n $antispam_tm_log | head -1

sum=0
sum=$(cat $antispam_tm_log | awk '{sum+=$1} END{print sum}')
amount=$(cat $antispam_tm_log | wc -l)
echo -n "antispam_tm ave value:"
echo $[$sum/$amount]
echo
echo


# -- ext_tm information --
#
ext_tm_log="ext_tm.log"
sed -n 's/.*ext_tm=\(.*\) ext_sv.*/\1/p' $exec_log_file > $ext_tm_log
echo -n "ext_tm max value:"
sort -nr $ext_tm_log | head -1

echo -n "ext_tm min value:"
sort -n $ext_tm_log | head -1

sum=0
sum=$(cat $ext_tm_log | awk '{sum+=$1} END{print sum}')
amount=$(cat $ext_tm_log | wc -l)
echo -n "ext_tm ave value:"
echo $[$sum/$amount]
echo
echo


#exec 3< $exec_log_file
#content="initalization"
#count=1

#while [ -n "$content" ]
#do
	#read content <&3
	#echo $content
#done

rm -fr $exec_log_file
rm -fr $get_tm_log
rm -fr $css_tm_log
rm -fr $data_path_tm_log
rm -fr $entity_tm_log
rm -fr $antispam_tm_log
rm -fr $ext_tm_log
#exec 3<&-
