#!/bin/bash
#set -x
set -o pipefail

TOP_DIR="/home/work/rts_rsync_rollback"
BIN_DIR="$TOP_DIR/bin/"
LOG_DIR="$TOP_DIR/log/"
CONF_DIR="$TOP_DIR/conf/"
FLAG_DIR="$TOP_DIR/flag/"

source "./alarm.sh"


if [ $# -eq 3 ] && [ $1 == "backup" ] || [ $1 == "rsync" ]
then
    echo -n
else
    echo "Usage: ./rts_env_check.sh     method     date +%Y%m%d      machine name   "
    echo "Usage: ./rts_env_check.sh  backup|rsync     20150514    check_machine_name"
    exit 1
fi


date=$2
machine_name=$3

if [ $1 == "backup" ]
then
    return_value=$(ssh $machine_name "[ -f $FLAG_DIR/backup_succ_$date ] && echo succ || echo failed")
else
    return_value=$(ssh $machine_name "[ -f $FLAG_DIR/rsync_succ_$date ] && echo succ || echo failed")
fi


if [ $return_value == "succ" ]
then
    echo "$machine_name $1 succ"
else
    #FATAL "$machine_name $1 failed."
    echo "$machine_name $1 failed."
fi
