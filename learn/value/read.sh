#!/bin/bash

# read -p option
# -n4 
read -n5 -p "Please enter your name :" name 

# echo -n option
echo -n "Please enter your age  :"
read age

echo "Your name is $name"
echo "Your age is "$age

# $REPLY value
read -p "Please input a string:"
for ECHO in $REPLY
do
	echo $REPLY
done

# read -t option 
echo "Please input your lover in 2s."
sleep 1
echo "Ready?"
sleep 1
echo "go!"
sleep 1
if read -n4 -t 2 -p "Please enter your lover:" lover
then
	echo 
	echo "Your lover is $lover"
else
	echo
	echo "Sorry,you are too slow"
fi

# read -s option
read -s -p "Please input your passwd :" passwd
echo 
echo "Your passwd is:"$passwd

# read from file
cat /etc/passwd | while read value
# also u can do like this:
# 1)
# exec 0< /etc/passwd
# while read value

# and like this:
# 2)
# for value in `< /etc/passwd`
do
	echo "The content is :" $value
done
echo "Finished."
