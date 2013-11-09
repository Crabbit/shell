#!/bin/bash

exec 3< name
#for command_name in `cat name`
command_name='initalization'
count=1
while [ $command_name ]
do
	read command_name <&3
	echo $command_name
	command_content=$(sed "s/\"/\'/g" $command_name)
	command_name=`echo $command_name | cut -d "." -f 1`
	echo "insert into bash_man(id,bash_man,bash_mean)values($count,\"$command_name\",\"$command_content\");" >> Insert.sh
	count=$[ $count + 1 ]
done
