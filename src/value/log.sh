#!/bin/bash
#
# Creat Time :Wed 06 Nov 2013 06:04:25 PM GMT
# Autoor     : lili

# use mktmp command to touch tmp file.

#tempdir=$(mktemp -d dir.XXXXX)
tempdir=`mktemp -d dir.XXXXX`
cd $tempdir

tempfile1=`mktemp temp1.XXXXX`
tempfile2=`mktemp temp2.XXXXX`

exec 5> $tempfile1
exec 6> $tempfile2

echo "This is normal." >&5
echo "This is error." >&6

# this will output file and stdout
# but, attention!!
# this will recover 
echo "Test tee1" | tee $tempfile1
# this will redirect to the file.
echo "Test tee2" >&5
echo "Test tee3" | tee -a $tempfile1
