#!/bin/bash
set -o pipefail
TOP_DIR=$(dirname $0)

if [ "${SOURCE_LOCK}" != "1" ]; then
    source "${TOP_DIR}/common.sh"
fi

function usage() {
    echo "Usage: op2_auto_update_yz.sh -d "
    echo "Try 'op2_auto_update_yz.sh -h' for more information."
    exit 1
}

function opt_help(){
    echo "Usage: auto_reflash.sh -c "
    echo "SYNOPSIS:"
    echo "    op2_auto_update_yz.sh"
    echo "    op2_auto_update_yz.sh -d [11012142]..."
    echo "Options:"
    echo "    -d |   Confirm date stamp."
}

function main(){
    local TIME_ARG=""

    while getopts "d:h" OPTION; do
        case $OPTION in
            d)  TIME_ARG="${OPTARG}" ;;
            h)  opt_help ;;
            \?) usage ;;
        esac
    done

    if [ -z "${TIME_ARG}" ];then
        echo "TIME_ARG is emputy,please confirm."
        exit 1
    fi

#   deploy new job
    sh -x ${BIN_DIR}/sofa_change_alias "online-dag-${TIME_ARG}" "sofacloudes-BUILD_RTS.dag-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/dag_${TIME_ARG}.online"

    #sh -x ${BIN_DIR}/sofa_change_alias "cserts-parser-online-single" "sofacloud-BUILD_RTS.cserts-parser-online-${TIME_ARG}"
    #[ "$?" -eq 0 ] && touch "${FLAG_DIR}/yq01_cserts_single_${TIME_ARG}.online"

    sh -x ${BIN_DIR}/sofa_change_alias "tbrts-parser-online-single" "sofacloud-BUILD_RTS.rtstb-parser-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/yq01_tbrts_single_${TIME_ARG}.online"

    sh -x ${BIN_DIR}/sofa_change_alias "yz-rts-parser-online-single" "sofacloud-BUILD_RTS.rts-parser-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/yz_rts_single_${TIME_ARG}.online"

    sh -x ${BIN_DIR}/sofa_change_alias "yz-wbrts-parser-online-single" "sofacloud-BUILD_RTS.rtswb-parser-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/yz_wbrts_single_${TIME_ARG}.online"

    sh -x ${BIN_DIR}/sofa_change_alias "yz-wiserts-parser-online-single" "sofacloud-BUILD_RTS.wiserts-parser-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/yz_wiserts_single_${TIME_ARG}.online"

#    switch st idc to new version in single
#    yq01: tc,nj,hz,gz,hnb
#    bjyz: st(new,single),st(old,batch)
    for kutype in rts wbrts wiserts; do
        sh -x step_reload.sh ${kutype} yq01 bjyz st </dev/null &>${LOG_DIR}/yq_2_yz_${kutype}_st.log 
        [ "$?" -ne '0' ] && FATAL_WARN "[RTS]Switch st to new version failed!!!"
        wait
        sleep 900
        case ${kutype} in
            rts) instance_mac="6.rts-transfer.build.bjyz" ;;
            wbrts) instance_mac="2.wbrts-transfer.build.bjyz" ;;
            wiserts) instance_mac="3.wiserts-transfer.build.bjyz" ;;
            \?) instance_mac="null" ;;
        esac
        avg_yz_single=$(monquery -n ${instance_mac} -t instance -i parser_send_to_udai_succ_cnt -d 10 -s "$(date -d '5 min ago' +%Y%m%d%H%M%S)" -e "$(date +%Y%m%d%H%M%S)" | awk '{sum+=$NF}END{avg=sum/NR;print avg}')
        avg_yq_single=$(monquery -n 0.${kutype}-transfer.build.yq01 -t instance -i parser_send_to_udai_succ_cnt -d 10 -s "$(date -d '5 min ago' +%Y%m%d%H%M%S)" -e "$(date +%Y%m%d%H%M%S)" | awk '{sum+=$NF}END{avg=sum/NR;print avg}')
        diff_yz_yq_single=$( echo "${avg_yz_single}-${avg_yq_single}" | bc )
        diff_yz_yq_single=$( echo ${diff_yz_yq_single#-} )
        diff_percent=$( echo "${diff_yz_yq_single} * 100 / ${avg_yq_single}" | bc)
        if [ ${diff_percent} -ge 40 ]; then
            ret=$( curl -d "msg=${kutype} op2 single error, pleask check!!!" http://xx.xx.xx.:xx/talk )
            exit 1
        fi
    done

#    watch
    sleep 30m
    return_www_status_jx_single=$(monquery -n unicorn-clean.build.yq01 -t instance -i PC_JX_STATUS -d 60 -s "$(date -d '30 min ago' +%Y%m%d%H%M%S)" -e "$(date +%Y%m%d%H%M%S)" | awk '{sum+=$NF}END{print sum}')
    [ ${return_www_status_jx_single} -ne '0' ] && FATAL_WARN "[single]Rts switch new job to jx idc,www warning!"

#    switch st idc to new version in all
#    yq01: tc,nj,hz,gz,hnb
#    bjyz: st(new,all)
    sh -x ${BIN_DIR}/sofa_change_alias "yz-rts-parser-online" "sofacloud-BUILD_RTS.rts-parser-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/yz_rts_all_${TIME_ARG}.online"

    sh -x ${BIN_DIR}/sofa_change_alias "yz-wbrts-parser-online" "sofacloud-BUILD_RTS.rtswb-parser-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/yz_wbrts_all_${TIME_ARG}.online"

    sh -x ${BIN_DIR}/sofa_change_alias "yz-wiserts-parser-online" "sofacloud-BUILD_RTS.wiserts-parser-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/yz_wiserts_all_${TIME_ARG}.online"

    sleep 30m
    avg_yz=$(monquery -n ${kutype}-transfer.build.bjyz -i parser_send_to_udai_succ_cnt_sum -d 10 -s "$(date -d '30 min ago' +%Y%m%d%H%M%S)" -e "$(date +%Y%m%d%H%M%S)" | awk '{sum+=$NF}END{avg=sum/NR;print avg}')
    avg_yq=$(monquery -n ${kutype}-transfer.build.yq01 -i parser_send_to_udai_succ_cnt_sum -d 10 -s "$(date -d '30 min ago' +%Y%m%d%H%M%S)" -e "$(date +%Y%m%d%H%M%S)" | awk '{sum+=$NF}END{avg=sum/NR;print avg}')
    diff_yz_yq=$( echo "${avg_yz}-${avg_yq}" | bc )
    diff_yz_yq=$( echo ${diff_yz_yq#-} )
    diff_percent=$( echo "${diff_yz_yq} * 100 / ${avg_yq}" | bc )
    if [ ${diff_percent} -ge 20 ]; then
        ret=$( curl -d "msg=${kutype} op2 st batch error, pleask check!!!" http://xx.xx.xx:xx/talk )
        exit 1
    fi
    return_www_status_jx=$(monquery -n unicorn-clean.build.yq01 -t instance -i PC_JX_STATUS -d 60 -s "$(date -d '30 min ago' +%Y%m%d%H%M%S)" -e "$(date +%Y%m%d%H%M%S)" | awk '{sum+=$NF}END{print sum}')
    [ ${return_www_status_jx} -ne '0' ] && FATAL_WARN "[all]Rts switch new job to jx idc,www warning!"
    touch "${FLAG_DIR}/${TIME_ARG}_single.succ"

    return 0
}

main "$@"
