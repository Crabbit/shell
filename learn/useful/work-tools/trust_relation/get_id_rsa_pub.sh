#!/bin/bash

mac_list="rts_hz_list"
auth_all="authorized_keys.hz_all"

for i in `cat $mac_list`
do
    file_status=$(ssh ${i} "test -f /home/work/.ssh/id_rsa.pub && echo exist || echo no_exist")
    if [ $file_status == "exist" ]
    then
        id_rsa_temp=$(ssh ${i} "cat /home/work/.ssh/id_rsa.pub")
        > id_rsa_pub.temp
        echo $id_rsa_temp > id_rsa_pub.temp
        md5_source=$(ssh ${i} "md5sum /home/work/.ssh/id_rsa.pub")
        md5_source=$(echo $md5_source | cut -d' ' -f 1| cut -f 1-32)
        md5_local=$(md5sum id_rsa_pub.temp)
        md5_local=$(echo $md5_local | cut -d' ' -f 1| cut -f 1-32)
        if [ $md5_source == $md5_local ]
        then
            echo $id_rsa_temp >> $auth_all
            echo "$i -> succ"
        else
            id_rsa_temp=$(ssh ${i} "cat /home/work/.ssh/id_rsa.pub")
            > id_rsa_pub.temp
            echo $id_rsa_temp > id_rsa_pub.temp
            md5_source=$(ssh ${i} "md5sum /home/work/.ssh/id_rsa.pub")
            md5_source=$(echo $md5_source | cut -d' ' -f 1| cut -f 1-32)
            md5_local=$(md5sum id_rsa_pub.temp)
            md5_local=$(echo $md5_local | cut -d' ' -f 1| cut -f 1-32)
            if [ $md5_source == $md5_local ]
            then
                echo $id_rsa_temp >> $auth_all
                echo "$i -> succ"
            fi
        fi
    fi
done

rm id_rsa_pub.temp

exit 0