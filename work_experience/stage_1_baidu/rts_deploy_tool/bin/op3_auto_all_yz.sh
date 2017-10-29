#!/bin/bash
set -o pipefail
TOP_DIR=$(dirname $0)

if [ "${SOURCE_LOCK}" != "1" ]; then
    source "${TOP_DIR}/common.sh"
fi

function usage() {
    echo "Usage: op3_auto_all_yz.sh -d "
    echo "Try 'op3_auto_all_yz.sh -h' for more information."
    exit 1
}

function opt_help(){
    echo "Usage: auto_reflash.sh -c "
    echo "SYNOPSIS:"
    echo "    op3_auto_all_yz.sh"
    echo "    op3_auto_all_yz.sh -d [11012142]..."
    echo "Options:"
    echo "    -d |   Confirm date stamp."
}

function main(){
    local TIME_ARG=""
    local ret="0"

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

    if [ ! -f "${FLAG_DIR}/${TIME_ARG}_single.succ" ]; then
        echo "Please check single result."
        exit 1
    fi

# all idc use new version
# yq01:
# bjyz; st,tc,nj,hz,gz,hnb
    for kutype in rts wbrts wiserts; do
        sh -x step_reload.sh ${kutype} yq01 bjyz "gz,hnb" </dev/null &>${LOG_DIR}/yq_2_yz_${kutype}_gz.log 
        ret="$(( $ret + $? ))"
        wait
        [ "${kutype}" == "rts" ] && sleep 300
        return_www_status_hn=$(monquery -n unicorn-clean.build.yq01 -t instance -i PC_HN_STATUS -d 60 -s "$(date -d '5 min ago' +%Y%m%d%H%M%S)" -e "$(date +%Y%m%d%H%M%S)" | awk '{sum+=$NF}END{print sum}')
        [ ${return_www_status_hn} -ne '0' ] && FATAL_WARN "[all]Rts switch new job to gz,gzhxy idc,www warning!"

        sh -x step_reload.sh ${kutype} yq01 bjyz "hz" </dev/null &>${LOG_DIR}/yq_2_yz_${kutype}_hz.log 
        ret="$(( $ret + $? ))"
        wait
        [ "${kutype}" == "rts" ] && sleep 300
        return_www_status_hz=$(monquery -n unicorn-clean.build.yq01 -t instance -i PC_HZ_STATUS -d 60 -s "$(date -d '5 min ago' +%Y%m%d%H%M%S)" -e "$(date +%Y%m%d%H%M%S)" | awk '{sum+=$NF}END{print sum}')
        [ ${return_www_status_hz} -ne '0' ] && FATAL_WARN "[all]Rts switch new job to hz idc,www warning!"

        sh -x step_reload.sh ${kutype} yq01 bjyz "nj" </dev/null &>${LOG_DIR}/yq_2_yz_${kutype}_nj.log 
        ret="$(( $ret + $? ))"
        wait
        [ "${kutype}" == "rts" ] && sleep 300
        return_www_status_nj=$(monquery -n unicorn-clean.build.yq01 -t instance -i PC_NJ_STATUS -d 60 -s "$(date -d '5 min ago' +%Y%m%d%H%M%S)" -e "$(date +%Y%m%d%H%M%S)" | awk '{sum+=$NF}END{print sum}')
        [ ${return_www_status_nj} -ne '0' ] && FATAL_WARN "[all]Rts switch new job to nj idc,www warning!"

        sh -x step_reload.sh ${kutype} yq01 bjyz "tc" </dev/null &>${LOG_DIR}/yq_2_yz_${kutype}_tc.log 
        ret="$(( $ret + $? ))"
        wait
        [ "${kutype}" == "rts" ] && sleep 300
        return_www_status_tc=$(monquery -n unicorn-clean.build.yq01 -t instance -i PC_TC_STATUS -d 60 -s "$(date -d '5 min ago' +%Y%m%d%H%M%S)" -e "$(date +%Y%m%d%H%M%S)" | awk '{sum+=$NF}END{print sum}')
        [ ${return_www_status_tc} -ne '0' ] && FATAL_WARN "[all]Rts switch new job to tc idc,www warning!"

# check
        sleep 60

        case ${kutype} in
            rts) yz_service_name="rts-transfer.build.bjyz"
                 check_mount="19" ;;
            wbrts) yz_service_name="wbrts-transfer.build.bjyz"
                 check_mount="12" ;;
            wiserts) yz_service_name="wiserts-transfer.build.bjyz"
                 check_mount="4" ;;
            \?) yz_service_name="null" ;;
        esac

        for instance_id in `get_instance_by_service -o ${yz_service_name} | awk '{print $NF}'`;do
            avg_yz_single_mac_amount=$( monquery -n "${instance_id}.${yz_service_name}" -t instance -i parser_send_to_udai_succ_cnt -d 10 -s "$(date -d '5 min ago' +%Y%m%d%H%M%S)" -e "$(date +%Y%m%d%H%M%S)" | awk '{sum+=$NF}END{avg=sum/NR;print avg}' | cut -d. -f 1 )
            if [ "${avg_yz_single_mac_amount}" -le "${check_mount}" ]; then
                FATAL_WARN "[Rts] Switch bjyz new job  to all idc error. error instance_name=${instance_id}.${yz_service_name}, Please check!"
                exit 1
            fi
        done

    done

    [ "${ret}" -ne "0" ] && FATAL_WARN "[all]Rts switch new job failed,Please check!"
    ret="0"

# watch 30min
#    sleep 30m

# yq01 use new version

    sh -x ${BIN_DIR}/sofa_change_alias "tbrts-parser-online" "sofacloud-BUILD_RTS.rtstb-parser-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/yq01_tbrts_all_${TIME_ARG}.online"

    sh -x ${BIN_DIR}/sofa_change_alias "rts-parser-online" "sofacloud-BUILD_RTS.rts-parser-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/yq01_rts_all_${TIME_ARG}.online"
    sh -x ${BIN_DIR}/sofa_change_alias "rts-parser-online-single" "sofacloud-BUILD_RTS.rts-parser-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/yq01_rts_single_${TIME_ARG}.online"

    sh -x ${BIN_DIR}/sofa_change_alias "wbrts-parser-online" "sofacloud-BUILD_RTS.rtswb-parser-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/yq01_wbrts_all_${TIME_ARG}.online"
    sh -x ${BIN_DIR}/sofa_change_alias "wbrts-parser-online-single" "sofacloud-BUILD_RTS.rtswb-parser-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/yq01_wbrts_single_${TIME_ARG}.online"

    sh -x ${BIN_DIR}/sofa_change_alias "wiserts-parser-online" "sofacloud-BUILD_RTS.wiserts-parser-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/yq01_wiserts_all_${TIME_ARG}.online"
    sh -x ${BIN_DIR}/sofa_change_alias "wiserts-parser-online-single" "sofacloud-BUILD_RTS.wiserts-parser-online-${TIME_ARG}"
    [ "$?" -eq 0 ] && touch "${FLAG_DIR}/yq01_wiserts_single_${TIME_ARG}.online"


    instance_id="0"
    check_mount="0"
# bjyz -> yq01
# yq01; tc,nj,hz,gz,hnb
# bjyz:
    for kutype in rts wbrts wiserts; do
        sh -x step_reload.sh ${kutype} bjyz yq01 all </dev/null &>${LOG_DIR}/yz_2_yq_${kutype}.log
        ret="$(( $ret + $? ))"
        wait
# check
        sleep 500

        case ${kutype} in
            rts) yq_service_name="rts-transfer.build.yq01"
                 check_mount="19" ;;
            wbrts) yq_service_name="wbrts-transfer.build.yq01"
                 check_mount="12" ;;
            wiserts) yq_service_name="wiserts-transfer.build.yq01"
                 check_mount="4" ;;
            \?) yq_service_name="null" ;;
        esac

        for instance_id in `get_instance_by_service -o ${yq_service_name} | awk '{print $NF}'`;do
            avg_yq_single_mac_amount=$( monquery -n "${instance_id}.${yq_service_name}" -t instance -i parser_send_to_udai_succ_cnt -d 10 -s "$(date -d '5 min ago' +%Y%m%d%H%M%S)" -e "$(date +%Y%m%d%H%M%S)" | awk '{sum+=$NF}END{avg=sum/NR;print avg}' | cut -d. -f 1 )
            if [ "${avg_yq_single_mac_amount}" -le "${check_mount}" ]; then
                FATAL_WARN "[Rts] Switch yq01 new job to all idc error. error instance_name=${instance_id}.${yq_service_name}, Please check!"
                exit 1
            fi
        done

    done

    [ "${ret}" -ne "0" ] && FATAL_WARN "[all]Rts switch bjyz to yq01 failed,Please check!"

    return 0
}

main "$@"
