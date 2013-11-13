#!/bin/bash
#
# Creat Time :Wed 13 Nov 2013 12:29:00 AM GMT
# Autoor     : lili

. ./function.sh

dialog --menu "System Admin menu" 20 30 10 1 \
"Display disk space" 2 "Display users" 3 "Display memory usage" \
4 "Exit" 2> log.txt

