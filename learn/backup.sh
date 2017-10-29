#!/bin/sh
#backup file

DATE='/bin/date +%Y%m%d'
/bin/tar -cf /backup/$1.$DATE.tar $1 > /dev/null 2 >> /backup/$1.bak.log
/bin/gzip /backup/$1.$DATE.tar
if [ $? -eq 0 ]
then
	echo "$1 $DATE backup succefully" >> /backup/$1.bak.log
else
	echo "ERROR: Failure $1 $DATE backup!" >> /backup/$1.bak.log
fi
