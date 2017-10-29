#!/bin/bash
set -x
set -o pipefail


DIR=`dirname $0`
CONF_DIR="$DIR/../conf/"
STATUS_DIR="$DIR/../status/"
FLAG_DIR="$DIR/../flag/"
LOG_DIR="$DIR/../log/"

EXCLUDE_CMD=""
RSYNC_INIT_CMD="rsync -av --bwlimit=10000 -e ssh"

HOSTNAME=`hostname`


source "$CONF_DIR/list.conf"
source "$DIR/alarm.sh"


# get source time host from option
# $1 dest rsync host 
# $2 time stamp
# $3 7 day ago time stamp
if [ $# -ne 3 ]
then
    echo "From $HOSTNAME: rts_env_rsync_fun.sh Invalid option." >&2  && echo 10 && exit 10
else
    DATE_STAMP=$2
    DATE_7_AGO=$3
    if [ "$1" == "localhost" ]
    then
# means backup
        SOURCE_HOST=$HOSTNAME
# backup path
        SAVE_RSYNC_DIR="$DIR/../rts_env_for_rollback/"
    else
        SOURCE_HOST="$1"
#  !!!  only save in /home/work/
        SAVE_RSYNC_DIR="/home/work/"
        ssh $SOURCE_HOST -oStrictHostKeyChecking=no "date"
        [ $? -ne 0 ] && echo "From $HOSTNAME: $1 connect timeout." >&2 &&  echo 20 && exit 20
    fi
fi


# rm old succ flag file
    [ -f "$FLAG_DIR"/"$rsync_src_dir_name"_SUCC_"$DATE_7_AGO" ] && rm "$FLAG_DIR"/"$rsync_src_dir_name"_SUCC_"$DATE_7_AGO"

# get the amount of need rsync dir
RSYNC_NEED_AMOUNT=${#RSYNC_REGISTER[*]} 
[ -z "${RSYNC_NEED_AMOUNT}" ] && FATAL "Can't get \$RSYNC_NEED_AMOUNT from list.conf"

count=0

while [ $count -lt $RSYNC_NEED_AMOUNT ]
do
    rsync_register_name=${RSYNC_REGISTER[$count]}

# creative rsync_status file
    > "$STATUS_DIR/$rsync_register_name".rsync_status_$(date +%Y%m%d)
# rm old rsync_status file
# save 7 days
    [ -f "$STATUS_DIR/$rsync_register_name".rsync_status_$(date -d "-7 day" +%Y%m%d) ] && rm "$STATUS_DIR/$rsync_register_name".rsync_status_$(date -d "-7 day" +%Y%m%d)
    

# get src value name
    rsync_src_value_name="$rsync_register_name"_src_dir
# get src dir name
    rsync_src_dir_name=$(eval echo \${${rsync_src_value_name}[0]})
    #echo $rsync_src_dir_name

# get exclude value name
    rsync_exclude_value_name="$rsync_register_name"_exclude_dir

# make the total cmd by exclude
    EXCLUDE_CMD=""
    if [ $( eval echo \${${rsync_exclude_value_name}[0]} ) != "null" ]
    then
        exclude_count=0
        while [ $exclude_count -lt $(eval echo \${#${rsync_exclude_value_name}[*]}) ]
        do
            exclude_filename=$(eval echo \${${rsync_exclude_value_name}[$exclude_count]})
            #echo $exclude_filename
            EXCLUDE_CMD="$EXCLUDE_CMD --exclude=$exclude_filename"
            exclude_count=$[ $exclude_count + 1 ]
        done
    fi

    for i in $(seq 1 3)
    do
        ssh $SOURCE_HOST -oStrictHostKeyChecking=no "date"
        if [ $? -eq 0 ]
        then
            break;
        else
            [ $i -eq 3 ] && FATAL "From $(hostname): ssh connect time out. src host: $HOSTNAME -> des host: $SOURCE_HOST"
            echo 20 && exit 20
        fi
        i=$[ $i + 1 ]
    done

    [ ! -d $SAVE_RSYNC_DIR/${RSYNC_REGISTER[$count]} ] && mkdir "$SAVE_RSYNC_DIR/${RSYNC_REGISTER[$count]}"
    $RSYNC_INIT_CMD $EXCLUDE_CMD $SOURCE_HOST:$rsync_src_dir_name/ $SAVE_RSYNC_DIR/${RSYNC_REGISTER[$count]} </dev/null &>"$STATUS_DIR/$rsync_register_name".rsync_status_$(date +%Y%m%d)
    CHK_RET FATAL "rsync $rsync_src_dir_name failed. rsync exit $?"

    count=$[ $count + 1 ]
done

if [ $1 == "localhost" ] 
then
    touch "$FLAG_DIR"/"backup_succ_"$DATE_STAMP
else
    touch "$FLAG_DIR"/"rsync_succ_"$DATE_STAMP
fi


echo 0
exit 0
