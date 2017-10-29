#!/bin/bash

set -o pipefail

CLUSTERS=(st tc nj hz gz hnb)
KUTYPE=(rts wiserts wbrts)
ENVI=(yq01 bjyz)
RETRY=3

rts_transfer_path="/home/work/rts-transfer"
script_path="${rts_transfer_path}/bin/mod_reload_udaiserv_conf.sh"
conf_path="${rts_transfer_path}/conf/udai_service.conf"
log_file="step_reload.log.`date "+%Y%m%d-%H:%M"`"

function FATAL_EXIT()
{
        if [ $# -ne 1 ]
        then
                echo "FATAL_EXIT need one param, $#"
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

function GET_HOSTS()
{
    [[ $# -eq 1 ]] || return 1
    local hosts_path=$1
    local idx=0
    local host_list
    while [ $idx -lt $RETRY ]
    do
        host_list=`get_hosts_by_path ${hosts_path} | sort`
        if [ x"${host_list}" == x"" ]
        then
            idx=`expr $idx + 1`
        else
            break
        fi
    done

    [[ x"${host_list}" == x"" ]] && return 1

    echo ${host_list}
}

function CHECK_CONSISTENCY()
{
    [[ $# -eq 2 ]] || FATAL_EXIT "CHECK_CONSISTENCY needs two params"
    local ku_type=$1
    local envi=$2
    local first_flag="True"
    local lclusters
    local tmp_clusters
    local hosts_path="${ku_type}-transfer.build.${envi}"

    host_list=`GET_HOSTS ${hosts_path}`

    [[ x"${host_list}" == x"" ]] && FATAL_EXIT "GET_HOSTS ${hosts_path} failed."

    for host in ${host_list}
    do
        if [ "${first_flag}" == "True" ]
        then
            lclusters=`ssh $host "dos2unix ${conf_path}&>/dev/null && cat ${conf_path} | grep dest_clusters"`
            SSH_RET $? $host
            lclusters=`echo $lclusters | awk -F: '{print $2}' | tr -d '
' | sed s/[[:space:]]//g`
            lclusters=(${lclusters//,/ })
            IFS=$'\n'
            lclusters=($(sort <<< "${lclusters[*]}"))
            unset IFS
            lclusters=($(awk -vRS=' ' '!a[$1]++' <<< ${lclusters[@]}))
            first_flag="False"
            echo "$host: ${lclusters[@]}"
        else
            tmp_clusters=`ssh $host "dos2unix ${conf_path}&>/dev/null && cat ${conf_path} | grep dest_clusters"`
            SSH_RET $? $host
            tmp_clusters=`echo $tmp_clusters | awk -F: '{print $2}' | tr -d '
' | sed s/[[:space:]]//g`
            tmp_clusters=(${tmp_clusters//,/ })
            IFS=$'\n'
            tmp_clusters=($(sort <<< "${tmp_clusters[*]}"))
            unset IFS
            tmp_clusters=($(awk -vRS=' ' '!a[$1]++' <<< ${tmp_clusters[@]}))
            echo "$host: ${tmp_clusters[@]}"
            [[ "${lclusters[@]}" == "${tmp_clusters[@]}" ]] || FATAL_EXIT "dest_clusters in $dst not equal"
        fi
    done
}

function GET_CLUSTERS()
{
    [[ $# -eq 2 ]] || return 1
    local ku_type=$1
    local envi=$2
    local hosts_path="${ku_type}-transfer.build.${envi}"
    local host=`GET_HOSTS ${hosts_path} | awk '{print $1}'`

    [[ x"${host}" == x"" ]] && return 1

    local clusters

    clusters=`ssh $host "dos2unix ${conf_path}&>/dev/null && cat ${conf_path} | grep dest_clusters"`
    SSH_RET $? $host
    clusters=`echo $clusters | awk -F: '{print $2}' | tr -d '
' | sed s/[[:space:]]//g`
    clusters=(${clusters//,/ })
    IFS=$'\n'
    clusters=($(sort <<< "${clusters[*]}"))
    unset IFS
    clusters=($(awk -vRS=' ' '!a[$1]++' <<< ${clusters[@]}))
    echo "${clusters[@]}"
}

function MODIFY_CLUSTERS()
{
    [[ $# -lt 2 ]] && FATAL_EXIT "MODIFY_CLUSTERS needs at least two params"
    local ku_type=$1
    local envi=$2
    local clusters=$3
    local hosts_path="${ku_type}-transfer.build.${envi}"

    local machine_list
    local err="False"

    local host_list=`GET_HOSTS ${hosts_path}`

    [[ x"${host_list}" == x"" ]] && err="True"

    for host in ${host_list}
    do
        echo "Reloading $host"
        local idx=0
        local ret=0
        while [ $idx -lt $RETRY ]
        do
            ssh $host "sh -x ${script_path} dest_clusters ${clusters}" 2>> $log_file
            ret=$?
            if [ $ret -ne 0 ]
            then
                idx=`expr $idx + 1`
            else
                break
            fi
        done
        if [ $ret -eq 0 ]
        then
            machine_list=("${machine_list[*]}" "${host}")
        else
            err="True"
            break
        fi
    done
    if [ "$err" == "True" ]
    then
        machine_list=`echo ${machine_list[@]}`
        if [ "$stage" == "add" ]
        then
            echo -e "\e[33mRolling\e[0m back ${dst}"
            [[ -z "${machine_list}" ]] || ROLL_BACK "$machine_list" $dst_clusters_str
        else
            echo -e "\e[33mRolling\e[0m back ${src}"
            [[ -z "${machine_list}" ]] || ROLL_BACK "$machine_list" $src_clusters_str
            dst_hosts_path="${ku_type}-transfer.build.${dst}"
            machine_list=`GET_HOSTS ${dst_hosts_path}`

            [[ x"${machine_list}" == x"" ]] && FATAL_EXIT "GET_HOSTS ${dst_hosts_path} failed."

            echo -e "\e[33mRolling\e[0m back ${dst}"
            ROLL_BACK "$machine_list" $dst_clusters_str
        fi
        exit 1
    fi
}

function ROLL_BACK()
{
    local machine_list=$1
    local clusters=$2
    clusters=(${clusters//,/ })
    for cluster in ${clusters[@]}
    do
        IN_ARRAY "$(echo ${CLUSTERS[@]})" $cluster
        [[ $? -eq 0 ]] || FATAL_EXIT "$cluster not in `echo ${CLUSTERS[@]}`"
    done

    for host in $machine_list
    do
        echo "Rolling back $host"
        local idx=0
        local ret=0
        while [ $idx -lt $RETRY ]
        do
            ssh $host "sh -x ${script_path} dest_clusters ${clusters}" 2>> $log_file
            ret=$?
            if [ $ret -ne 0 ]
            then
                idx=`expr $idx + 1`
            else
                break
            fi
        done
        [[ $ret -ne 0 ]] && echo "Roll back $host error, skipped."
    done
}

if [ $# -ne 4 -a $# -ne 3 -a $# -ne 2 ]
then
        echo -e "\e[31mUsage\e[0m: $0 ku_type src [dst [cluster]]"
        echo "    -ku_type: `echo ${KUTYPE[@]}`"
        echo "    -src/dst: `echo ${ENVI[@]}`"
        echo "    -cluster: `echo ${CLUSTERS[@]}`"
        echo -e "\e[32mExample\e[0m:"
        echo "    sh step_reload.sh rts yq01 #list all node info of rts at yq01"
        echo "    sh step_reload.sh rts yq01 bjyz #list node info of rts at yq01 and bjyz"
        echo "    sh step_reload.sh rts yq01 bjyz tc #change datapath to tc from yq01 to bjyz"
        exit 1
fi

ku_type=$1
src=$2
dst=$3
clusters=$4
if [ "${clusters}" == "all" ]
then
    clusters=("${CLUSTERS[@]}")
else
    clusters=(${clusters//,/ })
fi

[[ "${src}" != "${dst}" ]] || FATAL_EXIT "src is same to dst"

IN_ARRAY "$(echo ${ENVI[@]})" $src
[[ $? -eq 0 ]] || FATAL_EXIT "${src} not in `echo ${ENVI[@]}`"
#[[ "${ENVI[@]/$src/}" != "${ENVI[@]}" ]] || FATAL_EXIT "${src} not in `echo ${ENVI[@]}`"

IN_ARRAY "$(echo ${KUTYPE[@]})" $ku_type
[[ $? -eq 0 ]] || FATAL_EXIT "${ku_type} not supported"
#[[ "${KUTYPE[@]/${ku_type}/}" != "${KUTYPE[@]}" ]] || FATAL_EXIT "${ku_type} not supported"

[[ -f ${log_file} ]] || touch ${log_file}

src_hosts_path="${ku_type}-transfer.build.${src}"

#两个参数，列出指定环境所有节点机房配置信息
if [ $# -eq 2 ]
then
    host_list=`GET_HOSTS ${src_hosts_path}`
    [[ x"${host_list}" == x"" ]] && FATAL_EXIT "GET_HOSTS ${src_hosts_path} failed."

    for host in ${host_list}
    do
        src_clusters=`ssh $host "dos2unix ${conf_path}&>/dev/null && cat ${conf_path} | grep dest_clusters"`
        SSH_RET $? $host
        src_clusters=`echo $src_clusters | awk -F: '{print $2}' | tr -d '
' | sed s/[[:space:]]//g`
        src_clusters=(${src_clusters//,/ })
        IFS=$'\n'
        src_clusters=($(sort <<< "${src_clusters[*]}"))
        unset IFS
        src_clusters=($(awk -vRS=' ' '!a[$1]++' <<< ${src_clusters[@]}))
        echo -e "\e[1;32m${host}:\e[0m ${src_clusters[@]}"
    done
    exit 0
fi

IN_ARRAY "$(echo ${ENVI[@]})" $dst
[[ $? -eq 0 ]] || FATAL_EXIT "${dst} not in `echo ${ENVI[@]}`"
#[[ "${ENVI[@]/$dst/}" != "${ENVI[@]}" ]] || FATAL_EXIT "$dst not in `echo ${ENVI[@]}`"

if [ $# -eq 4 ]
then
    for cluster in ${clusters[@]}
    do
        IN_ARRAY "$(echo ${CLUSTERS[@]})" $cluster
        [[ $? -eq 0 ]] || FATAL_EXIT "$cluster not in `echo ${CLUSTERS[@]}`"
        #[[ "${CLUSTERS[@]/$cluster/}" != "${CLUSTERS[@]}" ]] || FATAL_EXIT "$cluster not in `echo ${CLUSTERS[@]}`"
    done
fi

#检查src环境所有机器配置是否一致
CHECK_CONSISTENCY $ku_type $src
src_clusters=(`GET_CLUSTERS $ku_type $src`)
[[ $? -ne 0 ]] && FATAL_EXIT "GET_CLUSTERS $ku_type $src failed."
src_clusters_str=`echo ${src_clusters[@]}`
src_clusters_str=${src_clusters_str// /,}

#检查dst环境所有机器配置是否一致
CHECK_CONSISTENCY $ku_type $dst
dst_clusters=(`GET_CLUSTERS $ku_type $dst`)
[[ $? -ne 0 ]] && FATAL_EXIT "GET_CLUSTERS $ku_type $dst failed."
dst_clusters_str=`echo ${dst_clusters[@]}`
dst_clusters_str=${dst_clusters_str// /,}

#输出当前src和dst环境机器配置信息
echo -e "\e[1;32m${src} clusters:\e[0m ${src_clusters[@]}"
echo -e "\e[1;32m${dst} clusters:\e[0m ${dst_clusters[@]}"

if [ $# -eq 3 ]
then
    exit 0
fi

#检查src环境机房信息是否为空
[[ -z "${src_clusters[@]}" ]] && FATAL_EXIT "dest_clusters in src is empty"

#检查将要做更改的机房是否在src环境中且不在dst环境中
for cluster in ${clusters[@]}
do
    IN_ARRAY "$(echo ${src_clusters[@]})" $cluster
    [[ $? -eq 0 ]] || FATAL_EXIT "$cluster not in ${src} clusters"
    #[[ "${src_clusters[@]/$cluster/}" != "${src_clusters[@]}" ]] || FATAL_EXIT "$cluster not in ${src} clusters"
    IN_ARRAY "$(echo ${dst_clusters[@]})" $cluster
    [[ $? -ne 0 ]] || FATAL_EXIT "$cluster already in ${dst} clusters"
    #[[ "${dst_clusters[@]/$cluster/}" == "${dst_clusters[@]}" ]] || FATAL_EXIT "$cluster already in ${dst} clusters"
done

for cluster in ${clusters[@]}
do
    dst_clusters=("${dst_clusters[*]}" "${cluster}")
done
n_dst_clusters_str=`echo ${dst_clusters[@]}`
n_dst_clusters_str=${n_dst_clusters_str// /,}

stage="add"
#修改dst环境机器配置信息
MODIFY_CLUSTERS $ku_type $dst $n_dst_clusters_str

#检查dst环境修改后所有机器配置是否一致
CHECK_CONSISTENCY $ku_type $dst

#输出修改dst环境后两套环境各自机器配置情况
echo -e "\e[33mAfter\e[0m change ${dst}:"
echo -e "\e[1;32m${src} clusters:\e[0m ${src_clusters[@]}"
echo -e "\e[1;32m${dst} clusters:\e[0m ${dst_clusters[@]}"


#删除src环境添加到dst环境的机器信息
for cluster in ${clusters[@]}
do
    src_clusters=("${src_clusters[@]/$cluster/}")
done
n_src_clusters_str=`echo ${src_clusters[@]}`
n_src_clusters_str=${n_src_clusters_str// /,}

stage="del"
MODIFY_CLUSTERS $ku_type $src $n_src_clusters_str

#检查src环境修改后所有机器配置信息是否一致
CHECK_CONSISTENCY $ku_type $src

echo -e "\n\e[33mFinal\e[0m result:"
echo -e "\e[1;32m${src} clusters:\e[0m ${src_clusters[@]}"
echo -e "\e[1;32m${dst} clusters:\e[0m ${dst_clusters[@]}"
