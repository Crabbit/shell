#!/bin/bash
#
# Creat Time :Wed 13 Nov 2013 04:10:38 AM GMT
# Autoor     : lili

gawk 'BEGIN {print "This is my first gawk!"}'

gawk '{print $1}' gawk_ifs.txt
echo 

gawk -F: '{print $1}' ./gawk_ifs.txt
echo 

gawk -F' ' '{print $1}' ./gawk_ifs.txt
echo

gawk -F' ' '{$4="Test"; print $0}' ./gawk_ifs.txt
echo

gawk -f gawk_ifs.script ./gawk_ifs.txt
