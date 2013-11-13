#!/bin/bash
#
# Creat Time :Tue 12 Nov 2013 11:54:17 PM GMT
# Autoor     : lili

. ./function.sh

# PS3 -- shell 脚本黄总使用select时的提示符.

PS3="Enter your option:"

select option in "Display disk space" "Display logged on users" \
"Display memory usage" "Exit program" "xixi" "gaga"
do
	case $option in 
		"Exit program")
		break ;;
		"Display disk space")
		disk_space ;;
		"Display logged on users")
		whoseon ;;
		"Display memory usage")
		memusage ;;
		"xixi")
		echo xixi ;;
		"gaga")
		echo gaga ;;
		*)
			clear
			echo "Sorry, wrong selection" ;;
	esac
done
clear
