#!/bin/bash
#纳新测试
OLD_IFS=$IFS
Result=0
CHANGE_ROOT=/home/last/.entrance/linux_root
ROOT=/

#########################################
# 1st question.
Test_String=$( tail -1 $CHANGE_ROOT/etc/inittab 2> /dev/null |cut -d ':' -f 2 )
if [ "$Test_String" == "3" ];then
		echo "Question 1 is right."
	else
		echo "Question 1 is false."
		Result=1
fi

#########################################
# 2nd question.
for Test_String in $( cat $CHANGE_ROOT/etc/resolv.conf 2> /dev/null | grep nameserver | cut -d ' ' -f 2)
do
	if [ "$Test_String" == "202.117.128.2" ];then
		Que2_Result=0
		break
	else
		Que2_Result=1
	fi
done
if [ "$Que2_Result" == "0" ];then
	echo "Question 2 is right"
else
	echo "Question 2 is false"
	Result=1
fi

#########################################
# 3rd question.
Test_String=$( cat $CHANGE_ROOT/etc/passwd 2> /dev/null |grep last )
if [ "$Test_String" == "last:x:505:505::/home/last:/bin/bash" ];then
	echo "Question 3 is right"
else
	echo "Question 3 is false"
	Result=1
fi

#########################################
# 4th question
#check the /etc/passwd file
Test_String=$( cat $CHANGE_ROOT/etc/passwd 2> /dev/null |grep lili )
if [ "$Test_String" == "lili:x:6000:6000::/home/lili:/bin/bash" ];then
		Que4_Result=0
else
		Que4_Result=1
fi

#check the /etc/shadow file
cat $CHANGE_ROOT/etc/shadow 2> /dev/null |grep lili >> /dev/null
if [ "$?" == "0" ];then
		Que4_Result=0
else
		Que4_Result=1
fi

Test_String=$( cat $CHANGE_ROOT/etc/shadow 2> /dev/null |grep lili 2> /dev/null | awk -F':' '{print NF-1}' )
if [ "$Test_String" == "8" ];then
		Que4_Result=0
else
		Que4_Result=1
fi

#check the /etc/group file
Test_String=$( cat $CHANGE_ROOT/etc/group 2> /dev/null |grep lili 2> /dev/null | cut -c 1-12 2> /dev/null )
if [ "$Test_String" == "lili:x:6000:" ];then
                Que4_Result=0
else
                Que4_Result=1
fi      
cat $CHANGE_ROOT/etc/group 2> /dev/null |grep lili |grep root |grep last >> /dev/null
if [ "$?" == "0" ];then
                Que4_Result=0
		
else
                Que4_Result=1
fi

#print information
if [ "$Que4_Result" == 0 ];then
	echo "Question 4 is right"
else
	echo "Question 4 is false"
	Result=1
fi

#########################################
# 5th question
if [ "$( cat $CHANGE_ROOT/proc/sys/net/ipv4/icmp_echo_ignore_all 2> /dev/null )" == "1" ];then
                Que5_Result=0
else
                Que5_Result=1
fi

if [ "$( cat $CHANGE_ROOT/etc/sysctl.conf 2> /dev/null |grep net.ipv4.icmp_echo_ignore_all |cut -d ' ' -f 3 2> /dev/null )" == "1" ];then
                Que5_Result=0
else
                Que5_Result=1
fi


#print information
if [ "$Que5_Result" == 0 ];then
	echo "Question 5 is right"
else
	echo "Question 5 is false"
	Result=1
fi

#########################################
# 6th question
if [ "$( cat $CHANGE_ROOT/etc/fstab 2> /dev/null| grep "rhel-server-6.3-x86_64.iso" | cut -d ' ' -f 1 )" == "$CHANGE_ROOT/home/last/rhel-server-6.3-x86_64.iso" ] && [ "$( cat $CHANGE_ROOT/etc/fstab 2> /dev/null | grep "rhel-server-6.3-x86_64.iso" | cut -d ' ' -f 3-4 )" == "iso9660 loop" ];then
	echo "Question 6 is right"
else
	echo "Question 6 is false"
	Result=1
fi

#########################################
# 7th question
if [ "$( cat $CHANGE_ROOT/boot/grub/grub.conf 2> /dev/null |grep default |cut -d '=' -f 2 )" == "1" ];then
	echo "Question 7 is right"
else
	echo "Question 7 is false"
	Result=1
fi

if [ "$Result" == "0" ];then
	echo -n "Please input your name:"
	read NAME
	echo -n "Pleae input your phone number:"
	read PHONE_NUMBER
	echo -n "Please input your Professional classes:"
	read CLASS
	echo -e " Name :$NAME \n Phone number : $PHONE_NUMBER \n Pro Classes : $CLASS " | mail -s New_member xiyou_linux@163.com
else
	echo "Scripts error"
fi
