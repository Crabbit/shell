#!/bin/bash
#
# Creat Time :Sat 09 Nov 2013 01:13:52 AM GMT
# Autoor     : lili

# Two ways to use function

# 1) function example
#    {
#    commands
#    }

# 2) example()
#    {
#    commands
#    }

# Attention:
# 1)
#   If you want to use function.
#   you must definition before you use it.
# 2)
#   The function name must be unique.
#   If you definition the function name
#   is the same with the last
#   the new will recover it.
# 3)
#   The return value is the last command return value.
#   you can use $? to show it.
#   Also,you can use return command to defintion return value.
#   but, the value must in 0 ~ 255

function example1
{
	echo "This is for test.--1111."
}

example1
example2

function example1
{
	echo "This is for test.--3333."
	read -p "Please input the return value:" value
	return $[ $value * 2 ]
}

example2()
{
	echo "This is for test.--2222."
	echo "1"
	echo "2"
	echo "3"
	echo "4"
	ls -l haha
}

example1
echo "The function example1 double value is :$?"

return_value=`example2`
echo "The function example2 return value is :$?"
echo "The function output is:"
echo $return_value
