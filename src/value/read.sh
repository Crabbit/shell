#!/bin/bash

# read -p option
# -n4 
read -n4 -p "Please enter your name :" name 

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
	echo "Your lover is $lover"
else
	echo
	echo "Sorry,you are too slow"
fi

#
