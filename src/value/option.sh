#!/bin/bash
# handling lots of parameters

# echo the 10th parameters -- ${}
echo ${10}

# using basename with the $0 parameter
echo $0
echo $( basename $0 )

# can ln the script for different name
# then,use the basename to execution
name=`basename $0`
if [ $name = "lili_1" ]
then
	echo "lili 1"
fi
if [ $name = "lili_2" ]
then
	echo "lili 2"
fi

# getting the number of parameters
echo "There is $# parameters."
# ${$#} means the last parameters
# but, we can't use $ in {}
# we can use ! instead of $
echo "The last parameters is ${!#}"

# testing $* and $@
# you can know the different of them
count=1
for parameters in "$*"
do
	echo "-- \$* Parameter #$count = $parameters"
	count=$[ $count + 1 ]
done

count=1
for parameters in "$@"
do
	echo "-- \$@ Parameter #$count = $parameters"
	count=$[ $count + 1 ]
done

# about the shift command
# Attention !!
# if you use shift command,you will lost the value!
# and you can't recovery it.
count=1
while [ -n "$1" ]
do
	echo "-- Parameter #$count = $1"
	count=$[ $count +1 ]
	shift
done

# about the getopt command
set -- `getopt abc:d "$@"`
while [ -n "$1" ]
do
	case "$1" in
	-a) echo "Found the -a option" ;;
	-b) echo "Found the -b option" ;;
	-c) echo "Found the -c option.With the parameters $2" ;;
	-d) echo "Found the -d option" ;;
	--) shift
		break;;
	*)  echo "$1 isnot an option";;	
	esac
	shift
done
