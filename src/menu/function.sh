#!/bin/bash
#
# Creat Time :Tue 12 Nov 2013 11:54:17 PM GMT
# Autoor     : lili

function disk_space
{
	clear
	df -h
}

function whoseon
{
	clear
	who
}

function memusage
{
	clear
	cat /proc/meminfo
	vmstat
}
