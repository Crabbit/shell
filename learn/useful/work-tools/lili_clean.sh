#!/bin/bash


#time : 2015-05-11
#
#这个脚本是清理目录用的
#一共用3个关键数组
#白名单，黑名单，用户列表
#




#定义等待清理目录
WAIT_CLEAN_DIR="/home/work"
#创建垃圾箱,用来回收垃圾文件
TRASH_DIR="trash_dir"
#文件存在列表，获取待清理目录下，一共有哪些文件
EXIST_LIST=$(ls "$WAIT_CLEAN_DIR")
cd $WAIT_CLEAN_DIR

#白名单
WHITE_LIST=(
opbin
opdir
)

#黑名单
BLACK_LIST=(
clean.sh.\*
fproxy.conf.\*
antispam.old
log
Log
hadoop-client.\*
)

#用户姓名列表
USERNAME_LIST=(
jishuo
dangersheng
lili
)

#定义5个temp文件，后面做名单过滤用
#而且注释掉最后面的rm操作，可以方便调试
WHITE_LIST_TEMP_FILE="white_list_tempfile"
NO_WHITE_LIST_TEMP_FILE="no_white_list_tempfile"
BLACK_LIST_TEMP_FILE="black_list_tempfile"
USERNAME_LIST_TEMP_FILE="username_list_tempfile"
EXIST_TEMP_FILE="exist_tempfile"


if [ "$?" -ne 0 ]
then
	echo "cd /home/work/ failed!";
	exit 1;
fi

if [ ! -d $TRASH_DIR ]
then
	mkdir $TRASH_DIR && echo "mkdir trash directory" && ls -l | grep $TRASH_DIR
fi

#echo "White list is:"
> $WHITE_LIST_TEMP_FILE
for white_file in `echo ${WHITE_LIST[*]}`
do
	echo $white_file >> $WHITE_LIST_TEMP_FILE
done

#echo "Black list is:"
> $BLACK_LIST_TEMP_FILE
for black_file in `echo ${BLACK_LIST[*]}`
do
	echo $black_file >> $BLACK_LIST_TEMP_FILE
done

#echo "Exist file:"
> $EXIST_TEMP_FILE
for exist_file in $EXIST_LIST
do
	echo $exist_file >> $EXIST_TEMP_FILE
done

#echo "user list"
> $USERNAME_LIST_TEMP_FILE
for user_list_file in `echo ${USERNAME_LIST[*]}`
do
	echo $user_list_file >> $USERNAME_LIST_TEMP_FILE
done


# *** 关键部分 ***  从当前目录文件中，剔除掉白名单列表的数据
#throw away white list file from exist file
no_white_list=$(fgrep -v -x -f $WHITE_LIST_TEMP_FILE $EXIST_TEMP_FILE )
> $NO_WHITE_LIST_TEMP_FILE
for i in $no_white_list
do 
	echo $i >> $NO_WHITE_LIST_TEMP_FILE
done

#从剔除白名单列表后的文件列表中，再执行mv操作
#mv user -> /home/work/opdir/
username_list=$(fgrep -x -f $NO_WHITE_LIST_TEMP_FILE $USERNAME_LIST_TEMP_FILE)
for i in $username_list
do
	echo $i;
	mv -v $i /home/work/opdir/$i/
done

#黑名单数据，一律mv到垃圾箱中
#filter black list file from no white list
only_black_list=$(fgrep -x -f $NO_WHITE_LIST_TEMP_FILE $BLACK_LIST_TEMP_FILE)
echo "Exist file in black list:"
for i in $only_black_list
do
	echo $i;
	mv -v $i $TRASH_DIR
done


if [ -f $WHITE_LIST_TEMP_FILE ]
then 
	rm -f $WHITE_LIST_TEMP_FILE
fi

if [ -f $NO_WHITE_LIST_TEMP_FILE ]
then 
	rm -f $NO_WHITE_LIST_TEMP_FILE
fi

if [ -f $BLACK_LIST_TEMP_FILE ]
then
	rm -f $BLACK_LIST_TEMP_FILE
fi

if [ -f $USERNAME_LIST_TEMP_FILE ]
then
	rm -f $USERNAME_LIST_TEMP_FILE
fi

if [ -f $EXIST_TEMP_FILE ]
then
	rm -f $EXIST_TEMP_FILE
fi

exit 0
