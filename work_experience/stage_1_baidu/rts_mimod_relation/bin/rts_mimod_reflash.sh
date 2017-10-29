#!/bin/bash

readonly DIR=$(dirname $0)
readonly TOP_DIR=$( cd ${DIR}/../; pwd )
readonly CONF_DIR="${TOP_DIR}/conf"
readonly BIN_DIR="${TOP_DIR}/bin"
readonly LOG_DIR="${TOP_DIR}/log"
readonly JSON_DIR="${TOP_DIR}/json"
readonly STATUS_DIR="${TOP_DIR}/status"
readonly DATA_DIR="${TOP_DIR}/data"
readonly TMP_DIR="${TOP_DIR}/tmp"

readonly COLOR_RED='\E[31;40m'
readonly COLOR_GREEN='\E[1;32;40m'
readonly COLOR_YELLOW='\E[1;33;40m'
readonly COLOR_CYAN='\E[1;36;40m'
readonly ERROR_INFO="${COLOR_RED}[Error  info]\E[0m" 
readonly SUCC_INFO="${COLOR_GREEN}[Succ   info]\E[0m"
readonly NOTICE_INFO="${COLOR_YELLOW}[notice info]\E[0m"

readonly JSON_CMD="${BIN_DIR}/JSON.sh"
#readonly SSH_CMD="ssh -o StrictHostKeyChecking=no -o PasswordAuthentication=no -o ConnectionAttempts=2  -o ConnectTimeout=4 -nq"
readonly SSH_CMD="ssh "
readonly RSYNC_CMD="rsync -av --bwlimit=50000 -e ssh"

source ${CONF_DIR}/rts_mimod_reflash.conf
source ${TOP_DIR}/bin/alarm.sh

ROLLBACK_SWITCH=0
ONLY_GRAY_SWITCH=0
REMOTE_MD5=0

function usage() {
    echo "Usage: rts_mimod_reflash.sh [-c] [-f idc_kutype_date] [-m idc_kutype_date md5 value]"
    echo "    rts_mimod_reflash.sh [option]..."
    echo "Options:"
    echo "    -f |   Specificed rts reflash mimod relation bs file list."
    echo "    -m |   Specificed file md5 value"
    echo "    -c |   Oonly gray level replace conf ,verification effect."
    echo "    -b |   Rollback to the last version."
    echo "Example:"
    echo "    reflash list: sh rts_mimod_reflash.sh -f st01-bat-con0.st01:/home/work/opdir/lili/rts/rts_mimod_relation/tmp/sh_wiserts_20160124"
    echo "    roll back   : sh rts_mimod_reflash.sh -b -f sh_wiserts_20160124"
    exit 1
}

function analysis_json_key_info(){
    cat "${JSON_DIR}/${RTS_MIMOD_FILENAME}" | sh ${JSON_CMD} -b
    [[ $? -ne '0' ]] && return 1

    IDC_json=$( cat ${JSON_DIR}/${RTS_MIMOD_FILENAME} | sh ${JSON_CMD} -b | grep -i "secure_info" | grep -i "idc" | awk '{print $NF}' | cut -d'"' -f 2)
    echo "IDC_json=${IDC_json} ==== IDC_filename=${IDC_filename}"
    [ "${IDC_json}" != "${IDC_filename}" ] && echo -e "${ERROR_INFO}-[function analysis_json_key_info] The IDC configuration is not consistent." && return 1
    KUTYPE_json=$( cat ${JSON_DIR}/${RTS_MIMOD_FILENAME} | sh ${JSON_CMD} -b | grep -i "secure_info" | grep -i "kutype" | awk '{print $NF}' | cut -d'"' -f 2)
    [ "${KUTYPE_json}" != "${KUTYPE_filename}" ] && echo -e "${ERROR_INFO}-[function analysis_json_key_info] The kutype configuration is not consistent." && return 1
    COLUME_AMOUTS=$( cat ${JSON_DIR}/${RTS_MIMOD_FILENAME} | sh ${JSON_CMD} -b | grep -i "secure_info" | grep -i "colume_amounts" | awk '{print $NF}' | cut -d'"' -f 2)
    SAME_RATE=$( cat ${JSON_DIR}/${RTS_MIMOD_FILENAME} | sh ${JSON_CMD} -b | grep -i "secure_info" | grep -i "same_rate" | awk '{print $NF}' | cut -d'"' -f 2)
    REMOTE_DATE_json=$( cat ${JSON_DIR}/${RTS_MIMOD_FILENAME} | sh ${JSON_CMD} -b | grep -i "secure_info" | grep -i "reflash_date" | awk '{print $NF}' | cut -d'"' -f 2)
    [[ "${REMOTE_DATE_json}" != "${REMOTE_DATE_filename}" ]] && echo -e "${ERROR_INFO}-[function analysis_json_key_info] The date configuration is not consistent." && return 1
    GRAY_MAC_IP=$( cat ${JSON_DIR}/${RTS_MIMOD_FILENAME} | sh ${JSON_CMD} -b | grep -i "secure_info" | grep -i "gray_machine_ip" | awk '{print $NF}' | cut -d'"' -f 2)
    GRAY_MAC_PORT=$( cat ${JSON_DIR}/${RTS_MIMOD_FILENAME} | sh ${JSON_CMD} -b | grep -i "secure_info" | grep -i "gray_machine_port" | awk '{print $NF}' | cut -d'"' -f 2)

#  sh-wiserts_0
#  sh-wiserts_11
    cat ${JSON_DIR}/${RTS_MIMOD_FILENAME} | sh ${JSON_CMD} -p | grep -vi "secure_info" |awk '{print $1}'| grep -e "^\[\"${IDC_json}-${KUTYPE_json}_[0-9]*\"\]$" | cut -d'"' -f 2 > "${STATUS_DIR}/all_colume_info.${REMOTE_DATE_json}"
    json_value_colume_amounts=$( cat "${STATUS_DIR}/all_colume_info.${REMOTE_DATE_json}" | wc -l )
    [[ "${json_value_colume_amounts}" -ne "${COLUME_AMOUTS}" ]] && echo -e "${ERROR_INFO}-[function analysis_json_key_info] The colume amounts onfiguration is not consistent." && return 1

#  ["sh-wiserts_0",0]      {"ip":"10.195.62.17","port":"11920","attr":"NEW"}
#  ["sh-wiserts_0",1]      {"ip":"10.195.26.37","port":11940,"attr":"OLD"}
#  ["sh-wiserts_11",0]     {"ip":"10.195.39.18","port":11940,"attr":"NEW"}
#  ["sh-wiserts_11",1]     {"ip":"10.195.27.35","port":12080,"attr":"OLD"}
    cat ${JSON_DIR}/${RTS_MIMOD_FILENAME} | sh ${JSON_CMD} -p | grep -vi "secure_info" | grep -e "^\[\"${IDC_json}-${KUTYPE_json}_[0-9]*\",[0-9]*\]" > "${STATUS_DIR}/all_mac_info.${REMOTE_DATE_json}"

    return 0
}

function gray_test(){
    [[ -z ${GRAY_MAC_IP} ]] && echo -e "${ERROR_INFO}-[function gray_test] The gray ip is null." && return 1
    [[ -z ${GRAY_MAC_PORT} ]] && echo -e "${ERROR_INFO}-[function gray_test] The gray port is null." && return 1

    local gray_conf_dir="${DATA_DIR}/gray.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json}"
    if [ -d "${gray_conf_dir}" ]; then
        local time_stamp=$( date +_%H%M%S )
        mv ${DATA_DIR}/gray.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json} ${DATA_DIR}/gray.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json}_${time_stamp}
    fi
    mkdir -p ${gray_conf_dir}

    local gray_conf="${gray_conf_dir}/conf"
    echo "[@Channel]" >>$gray_conf
    echo "  Number : 0" >> $gray_conf
    echo "  [.@Dispatcher]" >> $gray_conf
    echo "    Name : ${json_name_id}" >> $gray_conf
    echo "    MaxSpeed : -1" >> $gray_conf
    echo "    WatchType : 0" >> $gray_conf
    ip="${GRAY_MAC_IP}"
    port=$[ ${GRAY_MAC_PORT}+ 9 ]
    echo "    @Sender : ${ip}:${port}" >> $gray_conf

    local mac_name_top1=$( get_list ${KUTYPE_json} ${IDC_json} 2>&1 | grep -v "service not exist" | head -1  )
    ${SSH_CMD} ${mac_name_top1} "cd ${MIMO_WORK_BIN_DIR} && sh mimod_control stop "
    if [[ $? -eq '0' ]] ; then
        ${SSH_CMD} ${mac_name_top1} "cd ${MIMO_WORK_DATA_DIR}/index_branch_0 && mv conf backup_for_gray.conf"
    else
        echo -e "${ERROR_INFO}-[function gray_test] The stop mimod over time." && return 1
    fi

    if [[ $? -eq '0' ]]; then
        scp ${gray_conf} ${mac_name_top1}:${MIMO_WORK_DATA_DIR}/index_branch_0/ 
    else
        echo -e "${ERROR_INFO}-[function gray_test] stop mimod for gray test failed."
        return 1
    fi
    if [[ $? -eq '0' ]]; then
        ${SSH_CMD} ${mac_name_top1} "cd ${MIMO_WORK_BIN_DIR} && sh mimod_control start"
    else
        echo -e "${ERROR_INFO}-[function gray_test] Scp gray conf failed."
        return 1
    fi
    if [[ $? -eq '0' ]]; then
        gray_sender_info=$( show_mimo ${mac_name_top1} index_branch_0 | grep ${GRAY_MAC_IP} )
        gray_sender_status=$( echo ${gray_sender_info} | awk '{print $NF}' )
        if [ ${gray_sender_status} = '[Connecting]' ]; then
            ${SSH_CMD} ${mac_name_top1} "cd ${MIMO_WORK_BIN_DIR} && sh mimod_control stop"
            if [[ $? -eq '0' ]] ; then
                ${SSH_CMD} ${mac_name_top1} "cd ${MIMO_WORK_DATA_DIR}/index_branch_0 && mv conf conf.bad && mv backup_for_gray.conf conf && cd ${MIMO_WORK_BIN_DIR} && sh mimod_control start"
            else
                echo -e "${ERROR_INFO}-[function gray_test] The stop mimod over time." && return 1
            fi
            echo -e "${ERROR_INFO}-[function gray_test] Gray test result have problem, please check immediately!!!" && return 1
        fi
    else
        echo -e "${ERROR_INFO}-[function gray_test] mimod start failed."
        return 1
    fi

    echo -ne "${NOTICE_INFO} Please confirm gray test result, press y/Y to continue: "
    local count=1
    while true; do
        read gray_confirm_switch
        echo ${gray_confirm_switch} | grep -q "^[y|Y]$"
        if [[ $? -eq '0' ]]; then
            echo -e "${NOTICE_INFO} Confirm succ."
            break
        else
            [[ ${count} -ge 3 ]] && return 1 || count=$[ ${count} + 1 ]
            echo -e "${NOTICE_INFO} Please input y/Y to continue: "
        fi
    done

    return 0
}

function conf_replace(){
    [[ $# -ne 1 ]] && echo -e "${ERROR_INFO}-[function conf_replace] Arguments error."
    local mac_name=${1}

    ${SSH_CMD} ${mac_name} "cd ${MIMO_WORK_BIN_DIR} && sh mimod_control stop"
    [[ $? -ne '0' ]] && echo -e "${ERROR_INFO}-[function full_replace] ${mac_name} stop mimod have problem." && return 1
    ${SSH_CMD} ${mac_name} "cd ${MIMO_WORK_DATA_DIR}/ && rm -vfr index* && rm -v channel_list"
    scp -r ${DATA_DIR}/data.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json}/* ${mac_name}:${MIMO_WORK_DATA_DIR}/
    if [[ $? -eq 0 ]]; then
        ${SSH_CMD} ${mac_name} "cd ${MIMO_WORK_DATA_DIR}/ && md5sum channel_list" > ${TMP_DIR}/${mac_name}.after_replace_md5
        ${SSH_CMD} ${mac_name} "cd ${MIMO_WORK_DATA_DIR}/ && md5sum index*/conf " >> ${TMP_DIR}/${mac_name}.after_replace_md5
        diff "${TMP_DIR}/data.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json}.md5" "${TMP_DIR}/${mac_name}.after_replace_md5"
        if [[ $? -eq 0 ]]; then
            ${SSH_CMD} ${mac_name} "cd ${MIMO_WORK_BIN_DIR} && sh mimod_control start"
            [[ $? -eq 0 ]] && echo -e "${SUCC_INFO} ${mac_name} reflash mimod relation success."
            rm -v "${TMP_DIR}/${mac_name}.after_replace_md5"
        else
            ${SSH_CMD} ${mac_name} "cd ${MIMO_WORK_DATA_DIR}/ && rm -fr index* && rm channel_list"
            ${SSH_CMD} ${mac_name} "cp -r ${MIMO_BACKUP_DIR}/${DATE}/* ${MIMO_WORK_DATA_DIR}/"
            ${SSH_CMD} ${mac_name} "cd ${MIMO_WORK_BIN_DIR} && sh mimod_control start"
            echo -e "${ERROR_INFO}-[function full_replace] ${mac_name} replace conf file md5 is not same, stop replace operation." && return 1
        fi
    else
        echo -e "${ERROR_INFO}-[function full_replace] ${mac_name} replace conf file failed." && return 1
    fi
    return 0
}

function full_replace(){
    [[ ! -d "${DATA_DIR}/data.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json}" ]] && echo -e "${ERROR_INFO}-[function full_replace] Data dir is not exist." && return 1
    [[ -z "${KUTYPE_json}" ]] && echo -e "${ERROR_INFO}-[function full_replace] Kutype is emputy." && return 1
    [[ -z "${IDC_json}" ]] && echo -e "${ERROR_INFO}-[function full_replace] IDC is emputy." && return 1
    local mac_name=''
    local ret=0

    for mac_name in $( get_list ${KUTYPE_json} ${IDC_json} 2>&1 | grep -v "service not exist" ); do
        ${SSH_CMD} ${mac_name} "hostname" | grep -q "${mac_name}"
        [[ $? -ne 0 ]] && echo -e "${ERROR_INFO}-[function backup_data] ${mac_name} ssh connect abnormal." | tee -a ${LOG_DIR}/ssh_connect_abnormal.list.${IDC_json}.${KUTYPE_json}.${DATE}
        conf_replace ${mac_name}
        ret=$[ $? + $ret ]
    done
    return $ret
}

function diff_check(){
    [[ ! -d "${DATA_DIR}/data.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json}" ]] && echo -e "${ERROR_INFO}-[function diff_check] Data dir is not exist." && return 1
    $( cd "${DATA_DIR}/data.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json}" && cat index_branch_*/conf | grep -i Sender | awk -F" : " '{print $2}' | sort -n | uniq > ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_replace_ipport.list )

    local mac_name_top1=$( get_list ${KUTYPE_json} ${IDC_json} 2>&1 | grep -v "service not exist" | head -1  )
    ${SSH_CMD} ${mac_name} "cd ${MIMO_WORK_DATA_DIR}/ && cat index_branch_*/conf | grep -i Sender " | awk -F" : " '{print $2}' | sort -n | uniq > ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_online_ipport.list
    [[ $? -ne 0 ]] && echo -e "${ERROR_INFO}-[function diff_check] Get ip port information from ${mac_name_top1} failed." && return 1

    cat ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_online_ipport.list ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_replace_ipport.list | sort -n | uniq > ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_merge_ipport.list
    merge_num=$( cat ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_merge_ipport.list | wc -l )
    same_nume=$( fgrep -f ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_online_ipport.list ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_replace_ipport.list | wc -l )
    calc_same_rate=$[ ${same_nume} * 100 / ${merge_num} ]
    [[ ${calc_same_rate} -lt ${SAME_RATE} ]] && echo -e "${ERROR_INFO}-[function diff_check] The same rate json provide is too high." && return 1

    diff_info=$( diff ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_online_ipport.list ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_replace_ipport.list | grep ">\|<" | sort -t' ' -k 1,1)

    OLD_IFS=$IFS
    IFS=$'\n'
    for diff_line in $( diff ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_online_ipport.list ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_replace_ipport.list | grep ">\|<" | sort -t' ' -k 1,1 ); do
        char_info=$( echo ${diff_line} | cut -d' ' -f 1)
        ipport_info=$( echo ${diff_line} | cut -d' ' -f 2)
        if [ ${char_info} = '>' ]; then
            echo -e "${NOTICE_INFO} ${COLOR_GREEN}[+]\E[0m ${ipport_info}"
        else
            echo -e "${NOTICE_INFO} ${COLOR_RED}[-]\E[0m ${ipport_info}"
        fi
    done
    IFS=${OLD_IFS}
    
    rm ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_online_ipport.list
    rm ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_replace_ipport.list
    rm ${TMP_DIR}/${IDC_json}_${KUTYPE_json}_${REMOTE_DATE_json}_merge_ipport.list
    return 0
}

function backup_data(){
    [[ -z "${KUTYPE_json}" ]] && echo -e "${ERROR_INFO}-[function backup_data] Kutype is emputy." && return 1
    [[ -z "${IDC_json}" ]] && echo -e "${ERROR_INFO}-[function backup_data] IDC is emputy." && return 1

    #  backup  data
    for mac_name in $( get_list ${KUTYPE_json} ${IDC_json} 2>&1 | grep -v "service not exist" ); do
        ${SSH_CMD} ${mac_name} "hostname" | grep -q "${mac_name}"
        [[ $? -ne 0 ]] && echo -e "${ERROR_INFO}-[function backup_data] ${mac_name} ssh connect abnormal." | tee -a ${LOG_DIR}/ssh_connect_abnormal.list.${IDC_json}.${KUTYPE_json}.${DATE}

    if [ $( ${SSH_CMD} ${mac_name} "test -d ${MIMO_BACKUP_DIR}/${DATE} && echo 1" ) ]; then
        local time_stamp=$( date +_%H%M%S )
        ${SSH_CMD} ${mac_name} "mv ${MIMO_BACKUP_DIR}/${DATE} ${MIMO_BACKUP_DIR}/${DATE}_${time_stamp}"
    fi
        ${SSH_CMD} ${mac_name} "${RSYNC_CMD} --exclude=channel_00000 --exclude=fifo_* ${MIMO_WORK_DATA_DIR}/* ${MIMO_BACKUP_DIR}/${DATE}/"
        wait
        echo -e "${SUCC_INFO} Rsync backup succ."
    done

    #  check backup 
    for mac_name in $( get_list ${KUTYPE_json} ${IDC_json} 2>&1 | grep -v "service not exist" ); do
        ${SSH_CMD} ${mac_name} "cd ${MIMO_BACKUP_DIR}/${DATE}/ && md5sum index_branch_*/conf" > ${TMP_DIR}/${mac_name}.backup_md5
        ${SSH_CMD} ${mac_name} "cd ${MIMO_WORK_DATA_DIR}/ && md5sum index_branch_*/conf " > ${TMP_DIR}/${mac_name}.online_md5
        diff "${TMP_DIR}/${mac_name}.backup_md5" "${TMP_DIR}/${mac_name}.online_md5"
        if [[ $? -ne 0 ]]; then
            echo -e "${ERROR_INFO}-[function backup_data] ${mac_name} backup mimod information error."
            return 1
        else
            $( cd ${TMP_DIR} && rm ${mac_name}.backup_md5 && rm ${mac_name}.online_md5)
        fi
    done
    
    return 0
}

function conf_product(){
    analysis_json_key_info 
    ret=$?
    [[ $ret -ne 0 ]] && echo -e "${ERROR_INFO}-[function conf_product] Json format is error." && return $ret

    #  data/data.sh.wiserts.20160122
    local conf_dir="${DATA_DIR}/data.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json}"
    if [ -d "${conf_dir}" ]; then
        local time_stamp=$( date +_%H%M%S )
        mv "${DATA_DIR}/data.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json}" "${DATA_DIR}/data.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json}_${time_stamp}"
    fi

    mkdir -p "${conf_dir}"
    #  sh-wiserts_0
    #  sh-wiserts_11
    OLD_IFS=$IFS
    IFS=$'\n'
    for colume_info in $( cat "${STATUS_DIR}/all_colume_info.${REMOTE_DATE_json}" ); do
        local channel_id=$( echo ${colume_info##*_} )
        mkdir -p "${conf_dir}/index_branch_${channel_id}"
        local channel_conf="${conf_dir}/index_branch_${channel_id}/conf"
        > ${channel_conf}
        echo "[@Channel]" >>$channel_conf
        echo "  Number : 0" >> $channel_conf
        name_id=0

        #  ["sh-wiserts_0",0]      {"ip":"10.195.62.17","port":"11920","attr":"NEW"}
        #  ["sh-wiserts_0",1]      {"ip":"10.195.26.37","port":"11940","attr":"OLD"}
        for mac_info in $( cat "${STATUS_DIR}/all_mac_info.${REMOTE_DATE_json}" | grep -e "\[\"${colume_info}\"\,[0-9]*\]" ); do
            local json_name_id=$( echo "${mac_info}" | awk '{print $1}' | awk '{print $1}' | awk -F'",' '{print $2}' | cut -d] -f 1)
            [[ ${json_name_id} -ne ${name_id} ]] && echo -e "${ERROR_INFO} json channel mac amount is not sanme." && return 1

            echo "  [.@Dispatcher]" >> $channel_conf
            echo "    Name : ${json_name_id}" >> $channel_conf
            echo "    MaxSpeed : -1" >> $channel_conf
            echo "    WatchType : 0" >> $channel_conf
            local ip=$( echo "${mac_info}" | awk '{print $2}' | sed -n 's/.*\("ip":"\)\([0-9]*.[0-9]*.[0-9]*.[0-9]*\)\(","\).*/\2/p' )
            local port=$( echo "${mac_info}" | awk '{print $2}' | sed -n 's/.*\(","port":"\)\([0-9]*\).*/\2/p')
            port=$[ $port + 9 ]
            echo "    @Sender : ${ip}:${port}" >> $channel_conf
            name_id=$[ ${name_id} + 1 ]
        done
    done
    IFS=$OLD_IFS

    channel_amounts=$( ls -d ${conf_dir}/index_branch_* | wc -l)
    [[ ${channel_amounts} -ne ${COLUME_AMOUTS} ]] && echo -e "${ERROR_INFO} channel amounts is not the same with json config. check now!" && return 1

    local PORT_spider=5200
    local PORT_index_mimo=5300
    local PORT_index_branch_base=5500

    #  product channel_list file
    > "${conf_dir}/channel_list"
    echo "[@Channel]" >> "${conf_dir}/channel_list"
    echo "  Name : index" >> "${conf_dir}/channel_list"
    echo "  Port : ${PORT_index_mimo}" >> "${conf_dir}/channel_list"
    echo "  Hold : 0" >> "${conf_dir}/channel_list"
    echo "  Group:" >> "${conf_dir}/channel_list"
    echo "  UseOwnLoginHeader : 0" >> "${conf_dir}/channel_list"

    for colume_info in $( cat "${STATUS_DIR}/all_colume_info.${REMOTE_DATE_json}" ); do
        local channel_id=$( echo ${colume_info##*_} )
        echo "[@Channel]" >> "${conf_dir}/channel_list"
        echo "  Name : index_branch_${channel_id}" >> "${conf_dir}/channel_list"
        port=$[ ${PORT_index_branch_base} + ${channel_id} ]
        echo "  Port : ${port}" >> "${conf_dir}/channel_list"
        echo "  Hold : 0" >> "${conf_dir}/channel_list"
        echo "  Group:" >> "${conf_dir}/channel_list"
        echo "  UseOwnLoginHeader : 0" >> "${conf_dir}/channel_list"
    done

    echo "[@Channel]" >> "${conf_dir}/channel_list"
    echo "  Name : spider" >> "${conf_dir}/channel_list"
    echo "  Port : ${PORT_spider}" >> "${conf_dir}/channel_list"
    echo "  Hold : 0" >> "${conf_dir}/channel_list"
    echo "  Group:" >> "${conf_dir}/channel_list"
    echo "  UseOwnLoginHeader : 0" >> "${conf_dir}/channel_list"

    local index_dir="${conf_dir}/index"
    mkdir -p "${index_dir}"
    > "${index_dir}/conf"
    echo "[@Channel]" >> "${index_dir}/conf"
    echo "  Number : 0" >> "${index_dir}/conf"
    echo "  [.@Dispatcher]" >> "${index_dir}/conf"
    echo "    Name : index_split" >> "${index_dir}/conf"
    echo "    MaxSpeed : -1" >> "${index_dir}/conf"
    echo "    WatchType : 0" >> "${index_dir}/conf"
    for colume_info in $( cat "${STATUS_DIR}/all_colume_info.${REMOTE_DATE_json}" ); do
        local channel_id=$( echo ${colume_info##*_} )
        port=$[ ${PORT_index_branch_base} + ${channel_id} ]
        echo "    @Sender : 127.0.0.1:${port}" >> "${index_dir}/conf"
    done

    cd "${DATA_DIR}/data.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json}/" && md5sum channel_list > "${TMP_DIR}/data.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json}.md5"
    cd "${DATA_DIR}/data.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json}/" && md5sum index*/conf >> "${TMP_DIR}/data.${IDC_json}.${KUTYPE_json}.${REMOTE_DATE_json}.md5"
    return 0
}


function effect_check(){
    local remote_effect=0
    local local_effect=0
    return 0
}

function get_rts_mimod_file(){
    RTS_MIMOD_FILENAME=$( echo ${RTS_MIMOD_FILELINK##*/} )
    check_format=$( echo ${RTS_MIMOD_FILENAME} | sed -n '/^\(sh\|hz\|nj\|bj\|gzns\)_\(rts\|rtswb\|rtstb\|wiserts\|cserts\)_\([0-9]\{8\}\)/p' )
    [[ -z $check_format ]] && return 1
    IDC_filename=$( echo ${RTS_MIMOD_FILENAME} | awk -F'_' '{print $1}' )
    KUTYPE_filename=$( echo ${RTS_MIMOD_FILENAME} | awk -F'_' '{print $2}' )
    REMOTE_DATE_filename=$( echo ${RTS_MIMOD_FILENAME} | awk -F'_' '{print $3}' )

    if [ -f "${JSON_DIR}/${RTS_MIMOD_FILENAME}" ]; then
        local time_stamp=$( date +_%H%M%S )
        mv "${JSON_DIR}/${RTS_MIMOD_FILENAME}" "${JSON_DIR}/${RTS_MIMOD_FILENAME}${time_stamp}"
    fi
    $( cd ${JSON_DIR} && wget ${RTS_MIMOD_FILELINK} )
    if [ ! -f "${JSON_DIR}/${RTS_MIMOD_FILENAME}" ]; then
        echo -e "${ERROR_INFO}-[function get_rts_mimod_file] ${RTS_MIMOD_FILELINK} is not exist, Please check." && return 1
    else
        json_md5value=$( md5sum ${JSON_DIR}/${RTS_MIMOD_FILENAME} | awk '{print $1}' )
        echo -e "${SUCC_INFO} Receive ${COLOR_CYAN}${IDC_filename}_${KUTYPE_filename}_${REMOTE_DATE_filename}\E[0m json file success. "
        echo -e "${NOTICE_INFO} The json file ${COLOR_CYAN}${IDC_filename}_${KUTYPE_filename}_${REMOTE_DATE_filename}\E[0m md5value is : ${COLOR_GREEN}${json_md5value}\E[0m"
        if [[ "${REMOTE_MD5}" != "${json_md5value}" ]]; then
            echo -ne "${NOTICE_INFO} Please press y/Y to confirm: "
            local count=0
            while true; do
                read md5_confirm_switch
                echo ${md5_confirm_switch} | grep -q "^[y|Y]$"
                if [[ $? -eq '0' ]]; then
                    echo -e "${NOTICE_INFO} Confirm succ."
                    break
                else
                [[ ${count} -ge 3 ]] && return 1 || count=$[ ${count} + 1 ]
                    echo -ne "${NOTICE_INFO} Please input y/Y to continue: "
                fi
            done
        fi
    fi
    return 0
}

function rollback(){
    [[ $# -ne 1 ]] && echo -e "${ERROR_INFO}-[function rollback] Arguments error." && return 1
    roll_idc=$( echo ${1} | awk -F'_' '{print $1}' )
    roll_kutype=$( echo ${1} | awk -F'_' '{print $2}' )
    roll_date=$( echo ${1} | awk -F'_' '{print $3}' )
    [[ -z ${roll_idc} ]] && echo -e "${ERROR_INFO}-[function rollback] \$roll_idc is emputy." && return 1
    [[ -z ${roll_kutype} ]] && echo -e "${ERROR_INFO}-[function rollback] \$roll_kutype is emputy." && return 1
    [[ -z ${roll_date} ]] && echo -e "${ERROR_INFO}-[function rollback] \$roll_date is emputy." && return 1
    local mac_name=''

    recently_json_filename=$( ls -ltr ${JSON_DIR} | tail -1 | awk '{print $NF}' )

    json_idc=$( echo ${recently_json_filename} | awk -F'_' '{print $1}' )
    json_kutype=$( echo ${recently_json_filename} | awk -F'_' '{print $2}' )
    json_date=$( echo ${recently_json_filename} | awk -F'_' '{print $3}' )

    if [ "x${roll_idc}" == "x${json_idc}" -a "x${roll_kutype}" == "x${json_kutype}" -a "x${roll_date}" == "x${json_date}" ]; then
        for mac_name in $( get_list ${json_kutype} ${json_idc} 2>&1 | grep -v "service not exist" ); do
            ${SSH_CMD} ${mac_name} "hostname" | grep -q "${mac_name}"
            [[ $? -ne 0 ]] && echo -e "${ERROR_INFO}-[function backup_data] ${mac_name} ssh connect abnormal." | tee -a ${LOG_DIR}/ssh_connect_abnormal.list.${IDC_json}.${KUTYPE_json}.${DATE}

            ${SSH_CMD} ${mac_name} "cd ${MIMO_WORK_BIN_DIR} && sh mimod_control stop"
            [[ $? -ne '0' ]] && echo -e "${ERROR_INFO}-[function rollback] mimod stop have problem." && return 1
            ${SSH_CMD} ${mac_name} "cd ${MIMO_WORK_DATA_DIR}/ && rm -fr index* && rm channel_list"
            ${SSH_CMD} ${mac_name} "cp -r ${MIMO_BACKUP_DIR}/${DATE}/* ${MIMO_WORK_DATA_DIR}/"
            ${SSH_CMD} ${mac_name} "cd ${MIMO_WORK_BIN_DIR} && sh mimod_control start"
            [[ $? -ne '0' ]] && echo -e "${ERROR_INFO}-[function rollback] mimod start have problem." && return 1
            if [[ $? -eq 0 ]]; then
                echo -e "${SUCC_INFO} Roll back ${COLOR_CYAN}${roll_idc} ${roll_kutype} ${roll_date} \E[0m successful."
            fi
        done
    else
        echo -e "ERROR_INFO}-[function rollback] Argument is not same with recently json file."
    fi
    return 0
}

function main() {
    while getopts "f:m:chb:" OPTION; do
        case $OPTION in
            f)  RTS_MIMOD_FILELINK="${OPTARG}" ;;
            m)  REMOTE_MD5="${OPTARG}" ;;
            b)  ROLLBACK_SWITCH="1"
                rollback_info="${OPTARG}"
                ;;
            c)  ONLY_GRAY_SWITCH="1" ;;
            h) usage ;;
            \?) usage ;;
        esac
    done

    if [[ ${ROLLBACK_SWITCH} -eq 1 ]]; then
        rollback "${rollback_info}"
        exit 0
    fi

    get_rts_mimod_file
    ret=$?
############
    if [[ $ret -eq 0 ]]; then
        conf_product
        ret=$?
    else
        exit ${ret}
    fi

############
    if [[ $ret -eq 0 ]]; then
        backup_data
        ret=$?
    else
        exit ${ret}
    fi

############
    if [[ $ret -eq 0 ]]; then
        diff_check
        ret=$?
    else
        exit ${ret}
    fi

############
    if [[ $ret -eq 0 ]]; then
        gray_test
        ret=$?
        [[ ${ONLY_GRAY_SWITCH} -eq '1' ]] && exit ${ret}
    else
        exit ${ret}
    fi

############
    if [[ ${ret} -eq 0 ]]; then
        full_replace
        ret=$?
    else
        exit ${ret}
    fi
    [[ ${ret} -eq 0 ]] && echo -e "${SUCC_INFO} Reflash ${IDC_filename} ${KUTYPE_filename} success."
    exit ${ret}
}

main "$@"
