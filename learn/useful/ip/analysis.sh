#!/bin/bash
#
# Creat Time :Tue 11 Mar 2014 01:57:41 AM GMT
# Autoor     : lili

tempfile_swap=$( mktemp tempfile.XXX )
tempfile_result=$( mktemp tempfile.XXX )

#先把关键部分，做一个字符替换，方便后面切割出想要的数据
sed -e "
s/GET\ \//@/g
s/-\ -/@/g
s/HTTP/@/g
s/\ //g
" ip.txt > $tempfile_swap

#将替换后的数据，排序整理，切割
info=$( sort -k1 -n $tempfile_swap | cut -d "@" -f 1,3 )

#再进一步整理，将数据换行，然后写入文件，方便后面处理
echo $info | sed 's/\ /\n/g' > $tempfile_swap

#现在开始整理处理好的数据( 数据格式: ipaddress@资源 ,目标格式: ipaddress 请求次数 请求资源)
for info in $( cat $tempfile_swap )
do
	#以@为分隔符，从刚读取的数据行提取ipaddress
	ipaddr=$( echo $info | cut -d "@" -f 1 )
	#通过grep -c，统计刚提取出来的ipaddres出现次数
	times=$( cat $tempfile_swap | cut -d "@" -f 1 | grep -c $ipaddr )
	#以@为分隔符，从读取的数据行中提取请求资源
        resource=$( echo $info | cut -d "@" -f 2 )

	#将上面3步整理出来的数据重定向到文件
	echo "$ipaddr $times $resource" >> $tempfile_result
done

# 最终通过sed，来过滤请求次数为1，请求资源位index.html的字段
sed -n '/.\ 1\ index.html/p' $tempfile_result | cut -d " " -f 1 | xargs -n2

rm -fr $tempfile_swap
rm -fr $tempfile_result
