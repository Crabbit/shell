#!/bin/bash
set -x
set -o pipefail

TOP_DIR="/home/work/rts_rsync_rollback"
BIN_DIR="$TOP_DIR/bin/"
LOG_DIR="$TOP_DIR/log/"
CONF_DIR="$TOP_DIR/conf/"
FLAG_DIR="$TOP_DIR/flag/"

DATE_STAMP=$(date +%Y%m%d)
DATE_7_AGO=$(date -d "7 day ago" +%Y%m%d)

if [ $# -ne 1 ]
then
    echo "Usage: ./rts_env_backup.sh        option1  "
    echo "Usage: ./rts_env_backup.sh     machine_name"
    exit 1
fi

machine_name=$1
ssh $machine_name -oStrictHostKeyChecking=no "date"

if [ $? -ne 0 ]
then
    echo "$(hostname) -> ${machine_name} ssh connect time out." && exit 20
fi

md5_local=$(md5sum ./../conf/list.conf)
md5_local=$( echo $md5_local | cut -d' ' -f 1| cut -f 1-32 )
md5_remote=$( ssh $machine_name "cd $CONF_DIR &&  md5sum list.conf" )
md5_remote=$( echo $md5_remote | cut -d' ' -f 1| cut -f 1-32 )

[ -z $md5_local ] || [ -z $md5_remote ] && echo "list.conf error! check log." && exit 4

if [ $md5_local != $md5_remote ]
then
    echo "list.conf have changed. Please rsync."
    exit 5
fi

ssh $machine_name "cd  $BIN_DIR && nohup sh -x rts_env_rsync_fun.sh localhost $DATE_STAMP $DATE_7_AGO </dev/null &>./../log/rts_env_backup.log_$DATE_STAMP &" & 

sleep 5

nohup sh -x ./rts_env_check.sh backup $(date +%Y%m%d) $machine_name

exit 0
