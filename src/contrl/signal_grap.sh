#!/bin/bash
#
# Creat Time :Wed 06 Nov 2013 08:47:42 PM GMT
# Autoor     : lili

# ignore the ctrl-c singnal.
trap "echo ' Ignore the Ctrl-C singnal'" SIGINT SIGTERM

# catch the EXIT signal
# when you quit the shell
# will execution the command.
trap "echo Good bye~~bye~~bye~~bye~~" EXIT

# also, you can by the way,cancle the trap
trap - EXIT

echo "Ready!"
sleep 1
echo -n "Test!"
sleep 1
echo -n !
sleep 1
echo !
sleep 1
echo "Start!!!"
sleep 1

count=1
while [ $count -le 5 ]
do
	echo "Count loop is $count"
	sleep 3
	count=$[ $count + 1 ]
done

echo "Test Over."
