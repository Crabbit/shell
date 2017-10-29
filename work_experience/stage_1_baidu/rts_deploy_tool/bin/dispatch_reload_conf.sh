#!/bin/bash

if [ $# -lt 2 ]
then
        echo "Usage: $0 ku_type env dest_clusters"
        exit 1
fi

CLUSTERS=(st tc nj hz sh gz hnb)
KUTYPE=(rts wiserts wbrts)
ENVI=(yq01 bjyz)
RETRY=3

function FATAL_EXIT()
{
        if [ $# -ne 1 ]
        then
                echo "FATAL_EXIT need one param"
                exit 1
        fi
        echo -e "\033[31mError:\033[0m $1"
        exit 1
}

function SSH_RET()
{
    if [ $# -lt 1 ]
    then
        FATAL_EXIT "SSH_RET need ssh ret"
    fi
    local ret=$1
    local host=$2
    [[ $ret == 255 ]] && FATAL_EXIT "$host ssh error"
    [[ $ret == 127 ]] && FATAL_EXIT "$host exec cmd error"
    [[ $ret != 0 ]] && FATAL_EXIT "$host reload error"
}

function IN_ARRAY()
{
    [[ $# -eq 2 ]] || FATAL_EXIT "IN_ARRAY needs two params"
    local arr=$1
    local ele=$2
    for e in $arr
    do
        [[ "$e" == "$ele" ]] && return 0
    done
    return 1
}

ku_type=$1
environ=$2
dest_clusters=$3
if [ ! -z $dest_clusters ]
then
    if [ "${dest_clusters}" == "all" ]
    then
        clusters=("${CLUSTERS[@]}")
    elif [ "${dest_clusters}" == "none" ]
    then
        clusters=("")
    else
        clusters=(${dest_clusters//,/ })
    fi

    #remove duplicate
    clusters=($(awk -vRS=' ' '!a[$1]++' <<< ${clusters[@]}))
    dest_clusters=`echo ${clusters[@]}`
    dest_clusters=${dest_clusters// /,}

    for cluster in ${clusters[@]}
    do
        [[ "${CLUSTERS[@]/$cluster/}" != "${CLUSTERS[@]}" ]] || FATAL_EXIT "$cluster not in clusters"
    done
fi

IN_ARRAY "$(echo ${KUTYPE[@]})" $ku_type
[[ $? -eq 0 ]] || FATAL_EXIT "${ku_type} not supported"
#[[ "${KUTYPE[@]/${ku_type}/}" != "${KUTYPE[@]}" ]] || FATAL_EXIT "${ku_type} not supported"

IN_ARRAY "$(echo ${ENVI[@]})" $environ
[[ $? -eq 0 ]] || FATAL_EXIT "${environ} not in `echo ${ENVI[@]}`"
#[[ "${ENVI[@]/$environ/}" != "${ENVI[@]}" ]] || FATAL_EXIT "env not in `echo ${ENVI[@]}`"


rts_transfer_path="/home/work/rts-transfer"
script_path="${rts_transfer_path}/bin/mod_reload_udaiserv_conf.sh"
conf_path="${rts_transfer_path}/conf/udai_service.conf"

hostspath="${ku_type}-transfer.build.${environ}"

for host in `get_hosts_by_path ${hostspath} | sort`
do
    idx=0
    ret=0
    while [ $idx -lt $RETRY ]
    do
        ssh $host "sh -x ${script_path} dest_clusters ${dest_clusters}" &> dispatch_reload_conf.log
        ret=$?
        if [ $ret -ne 0 ]
        then
            idx=`expr $idx + 1`
        else
            break
        fi
    done
    SSH_RET $ret $host
done

first_flag="True"
for host in `get_hosts_by_path ${hostspath} | sort`
do
    if [ "${first_flag}" == "True" ]
    then
        dst_clusters=`ssh $host "cat ${conf_path} | grep dest_clusters"`
        SSH_RET $? $host
	dst_clusters=`echo $dst_clusters | awk -F: '{print $2}' | tr -d '' | sed s/[[:space:]]//g`
        dst_clusters=(${dst_clusters//,/ })
	IFS=$'\n'
	dst_clusters=($(sort <<< "${dst_clusters[*]}"))
	unset IFS
        dst_clusters=($(awk -vRS=' ' '!a[$1]++' <<< ${dst_clusters[@]}))
        first_flag="False"
    else
        tmp_clusters=`ssh $host "cat ${conf_path} | grep dest_clusters"`
        SSH_RET $? $host
	tmp_clusters=`echo $tmp_clusters | awk -F: '{print $2}' | tr -d '' | sed s/[[:space:]]//g`
        tmp_clusters=(${tmp_clusters//,/ })
	IFS=$'\n'
	tmp_clusters=($(sort <<< "${tmp_clusters[*]}"))
	unset IFS
        tmp_clusters=($(awk -vRS=' ' '!a[$1]++' <<< ${tmp_clusters[@]}))
        [[ "${dst_clusters[@]}" == "${tmp_clusters[@]}" ]] || FATAL_EXIT "dest_clusters in dst not equal"
    fi
done

echo -e "\e[1;32mresult:\e[0m ${dst_clusters[@]}"
