#!/bin/bash
CpuTotal1=$(mpstat  | tail -1 | gawk -F" " '{print $3+$4+$5+$6+$7+$8+$9+$10}')
CpuUsed1=$(mpstat | tail -1 | gawk -F" " '{print $3+$4+$5+$7+$8}')
#echo -n CPU total1 :  
#echo $CpuTotal1
#echo -n CPU used1  : 
#echo $CpuUsed1

sleep 1

CpuTotal2=$(mpstat  | tail -1 | gawk -F" " '{print $3+$4+$5+$6+$7+$8+$9+$10}')
CpuUsed2=$(mpstat | tail -1 | gawk -F" " '{print $3+$4+$5+$7+$8}')
#echo -n CPU total2 :  
#echo $CpuTotal2
#echo -n CPU used2  : 
#echo $CpuUsed2

echo "$CpuUsed2 $CpuUsed1 $CpuTotal2 $CpuTotal1" | gawk -F" " '{print ($1-$2)*100/($3-$4+1)}'

MemInfo=$(free -m | head -2 | tail -1 | gawk -F" " '{print $4}')
echo -n Memory information :  
echo $MemInfo

RecvNet=$(ifconfig eth0 | grep bytes | cut -dT -f1 | cut -d: -f 2 | cut -d' ' -f 1)
echo -n Receive network  :  
echo $RecvNet

SendNet=$(ifconfig eth0 | grep bytes | cut -dT -f2 | cut -d: -f 2 | cut -d' ' -f 1)
echo -n Send network  :  
echo $SendNet

IORead=$(iostat -d -k | head -4 | tail -1 | awk -F" " '{print $5}')
echo -n I/O Read  :  
echo $IORead

IOWrit=$(iostat -d -k | head -4 | tail -1 | awk -F" " '{print $6}')
echo -n I/O Write :
echo $IOWrit

HomeSize=$(df -h | grep home | gawk -F" " '{print $4}')
echo -n Home partition  :  
echo $HomeSize

RootSize=$(df -h | gawk -F" " '{if ($6=="/"){print $4}}' )
echo -n Root partition  :  
echo $RootSize

Time=$(date +%Y-%m-%d-%k-%M-%S)
echo -n Time  :  
echo $Time

echo

#2 days
#2880 min
#total 28800


# crontab
# * * * * * sh wiki.sh >> information.txt;tail -2880 > information.txt 
