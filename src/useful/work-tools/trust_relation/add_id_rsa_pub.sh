#!/bin/bash

mac_list="rts_hz_list"
AUTH_FILE="authorized_keys.hz_all"

md5_local=$(md5sum $AUTH_FILE | cut -d' ' -f 1| cut -f 1-32 )

#for i in "m1-rts-build1.m1"
for i in `cat $mac_list`
do
    cp_status=$(ssh ${i} "cd /home/work/.ssh/ && cp authorized_keys authorized_keys.20150512 && echo succ || echo failed")
    if [ $cp_status == "succ" ]
    then
        scp $AUTH_FILE ${i}:/home/work/.ssh/
        md5_remote=$(ssh ${i} "md5sum /home/work/.ssh/$AUTH_FILE")
        md5_remote=$(echo $md5_remote | cut -d' ' -f 1| cut -f 1-32 )
        if [ $md5_local == $md5_remote ]
        then
            ssh ${i} "cd /home/work/.ssh/ && cat authorized_keys >> $AUTH_FILE && sort $AUTH_FILE | uniq > authorized_keys && rm $AUTH_FILE"
        fi
    fi
done

exit 0