#!/bin/bash

readonly DIR=$(dirname $0)
readonly TOP_DIR=$( cd ${DIR}/../; pwd )
readonly CONF_DIR="${TOP_DIR}/conf"
readonly LOG_DIR="${TOP_DIR}/log"
readonly STATUS_DIR="${TOP_DIR}/status"
readonly BIN_DIR="${TOP_DIR}/bin"
readonly TMP_DIR="${TOP_DIR}/tmp"
readonly FLAG_DIR="${TOP_DIR}/flag"

readonly JSON_CMD="${BIN_DIR}/JSON.sh"

source ${TOP_DIR}/bin/alarm.sh &>/dev/null
source ${CONF_DIR}/conf.sh

#set -x

# bugs: TIME_STAMP define in conf.sh, it shuould be a option, but I have no time to fix it.

# curl http://xx.xx.xx.xx:8888/list
function API_ALIAS_show_alias(){
    local alias_name=""
    local job_name=""
    curl http://${API_ALIAS_MACHINE}list 2>/dev/null > ${TMP_DIR}/api_alias.result

    OLD_IFS=$IFS
    IFS=$'\n'
    echo -e "${COLOR_YELLOW}       Alias name                          |              Job name\E[0m"
    echo -e "${COLOR_RED}---------------------------------------------------------------------------------------------------\E[0m"
    for line in `cat ${TMP_DIR}/api_alias.result | sh ${JSON_CMD} -b `; do
        alias_name=$(echo ${line} | awk -F '"' '{print $2}' )
        job_name=$(echo ${line} | awk -F '"' '{print $7}' | cut -d'\' -f 1 )
        printf "${COLOR_CYAN} %-40s \E[0m |        ${COLOR_GREEN}%s\E[0m\n" "${alias_name}"  "${job_name}"
    done
    IFS=${OLD_IFS}

    return "$?"
}


function API_ALIAS_change_alias(){
    local alias_name=""
    local job_name=""

    if [ "$#" -eq 2 ] && [ ! -z "${1}" ] && [ ! -z "${2}" ]; then
        alias_name="${1}"
        job_name="${2}"
    else
        echo -e "Usage: ${COLOR_RED}[Alias name]\E[0m ${COLOR_MAGENTA}[Job name]\E[0m"
        return 1
    fi
    echo -e "${COLOR_RED}Goal:\E[0m ${COLOR_CYAN} ${alias_name} \E[0m ---> ${COLOR_GREEN} ${job_name}\E[0m"
    curl -X PUT http://${API_ALIAS_MACHINE} -d "alias=${alias_name}" -d "job_name=${job_name}" -d "username=${ALIAS_USERNAME}" -d "password=${ALIAS_PASSWORD}" -d "async=1"

    return "$?"
}



function API_ALIAS_delete_alias(){
    local alias_name=""
    local job_name=""

    if [ "$#" -eq 1 ] && [ ! -z "${1}" ]; then
        alias_name="${1}"
    else
        echo -e "Usage: ${COLOR_RED}[Alias name]\E[0m"
        return 1
    fi
    echo -e "${COLOR_RED}Goal:\E[0m Delete ${COLOR_CYAN} ${alias_name} \E[0m"
    curl -X PUT http://${API_ALIAS_MACHINE}delete -d "alias=${alias_name}"

    return "$?"
}

function API_APP_delete_version(){
    # curl -X DELETE "http://10.xxx.xx.xx:8110/fs/ver?name=app_name&user=&version=ver_1_0_0"
    if [ "$#" -eq 2 ] && [ ! -z "${1}" ] && [ ! -z "${2}" ]; then
        local app_name="${1}"
        local version="${2}"
    else
        echo -e "Usage: ${COLOR_RED} [App name] [Version]\E[0m"
        return 1
    fi

    curl -X DELETE "http://${API_APP_MACHINE}/fs/ver?name=${app_name}&user=${CREATOR}&version=${version}"

    return "$?"
}

function API_APP_UPGRADE_FULL(){
    if [ "$#" -eq 2 ] && [ ! -z "${1}" ] && [ ! -z "${2}" ]; then
        local app_name="${1}"
        local version="${2}"
    else
        echo -e "Usage: ${COLOR_RED} [App name] [Version]\E[0m"
        return 1
    fi

    curl -X PUT "http://${API_APP_MACHINE}/fs/upgrade" \
        -d pretty=1 \
        -d name="${app_name}" \
        -d user="${CREATOR}" \
        -d version="${version}"

    return "$?"
}

#curl -X POST "http://10.xx.xx.xx:xx/fs/register" \
##    -d name="ps-test-app3" \
#    -d creator=xx\
#    -d admins="xx" \
#    -d prod=test \
#    -d type=cs \
#    -d min_inst=2 \
#    -d max_inst=2 \
#    -d usable=50 \
#    -d inst_per_host=1
function API_APP_register_cs_app(){
    local cs_app_name=""
    local register_kutype=""
    if [ "$#" -eq 1 ] && [ ! -z "${1}" ]; then
        cs_app_name="${1}"
    else
        echo -e "Usage: ${COLOR_RED}[App name]\E[0m"
        return 1
    fi
    register_kutype=$( echo ${cs_app_name} | cut -d'-' -f 1 )
    case "${register_kutype}" in
        rts) INSTANCE_MIN="${RTS_PARSER_INSTANCE_MIN}"
             INSTANCE_MAX="${RTS_PARSER_INSTANCE_MAX}" ;;
        rts_noanti) INSTANCE_MIN="${RTS_PARSER_INSTANCE_MIN}"
             INSTANCE_MAX="${RTS_PARSER_INSTANCE_MAX}" ;;
        rtswb) INSTANCE_MIN="${RTSWB_PARSER_INSTANCE_MIN}"
             INSTANCE_MAX="${RTSWB_PARSER_INSTANCE_MAX}" ;;
        rtstb) INSTANCE_MIN="${RTSTB_PARSER_INSTANCE_MIN}"
             INSTANCE_MAX="${RTSTB_PARSER_INSTANCE_MAX}" ;;
        cserts) INSTANCE_MIN="${CSERTS_PARSER_INSTANCE_MIN}"
             INSTANCE_MAX="${CSERTS_PARSER_INSTANCE_MAX}" ;;
        wiserts) INSTANCE_MIN="${WISERTS_PARSER_INSTANCE_MIN}"
             INSTANCE_MAX="${WISERTS_PARSER_INSTANCE_MAX}" ;;
        \?) echo "kutype is error.Please check!" && exit 1 ;;
    esac

    curl -X POST "http://${API_APP_MACHINE}/fs/register" \
        -d name="${cs_app_name}" \
        -d creator="${CREATOR}" \
        -d admins="${SOFA_ADMINS}" \
        -d prod="${PROD}" \
        -d type="cs" \
        -d min_inst="${INSTANCE_MIN}" \
        -d max_inst="${INSTANCE_MAX}" \
        -d usable="${USABLE}" \
        -d inst_per_host="${INSTANCE_PER_HOST}" \
        -d token="${TOKEN}"

    return "$?"
}

# curl -X DELETE "http://10.xxx.xxx.xxx:8110/fs/job?name=cserts-parser-online-09181318&user="
function API_APP_stop_app(){
    if [ "$#" -eq 1 ] && [ ! -z "${1}" ]; then
        app_name="${1}"
    else
        echo -e "Usage: ${COLOR_RED}[App name]\E[0m"
        return 1
    fi
    curl -X DELETE "http://${API_APP_MACHINE}/fs/job?name=${app_name}&user=&token=${TOKEN}"

    return "$?"
}

# curl -X POST "http://api.xxx.com:80/fs/job" \
# -d pretty=1 \
# -d name="rtstb-parser-online-09181318" \
# -d user=xx \
# -d version=ver_1_0_0
function API_APP_start_app(){
    if [ "$#" -eq 3 ] && [ ! -z "${1}" ] && [ ! -z "${2}" ] && [ ! -z "${3}" ]; then
        local app_type="${1}"
        local kutype="${2}"
        local time_region="${3}"
    else
        echo -e "Usage: ${COLOR_RED} [App name] [cs | es] [09282209]\E[0m"
        return 1
    fi

    case ${app_type} in
        cs) echo "Start cs app..."
            curl -X POST "http://${API_APP_MACHINE}/fs/job" \
                -d pretty=1 \
                -d name="${kutype}-parser-online-${time_region}" \
                -d user="" \
                -d version="ver_1_0_0" \
                -d token="${TOKEN}"
            ;;
        es) echo "Start es app..."
            curl -X POST "http://${API_APP_MACHINE}/fs/job" \
                -d name="${kutype}-online-${time_region}" \
                -d user="" \
                -d type="es" \
                -d token="${TOKEN}" \
                -d start_topo="[ \
                         {\"app_name\":\"rts-dag-app-lili-PE1-${time_region}\",\"version\":\"ver_1_0_0\"}, \
                         {\"app_name\":\"rts-dag-app-lili-PE2-${time_region}\",\"version\":\"ver_1_0_0\"}]"
            ;;
        \?)  echo -e "App type is ${COLOR_RED} cs \E[0m or ${COLOR_RED} es \E[0m.";;
    esac

    return "$?"
}


#curl -X POST "http://10.xx.xx.xx:xx/fs/register" \
#    -d name="es-test" \
#    -d creator=xxx \
#    -d admins="xxx" \
#    -d prod=test \
#    -d type=es \
#    -d topo="[ \
#             {\"name\":\"es-test-PE1\",\"confid\":1,\"max_inst\":10, \"min_inst\":1, \"usable\":70, \"inst_per_host\":1, \"itfc\":\"ps.antispam.framework.ver_1_0_0.Antispam\", \"method\":\"run\"}, \
#             {\"name\":\"es-test-PE2\",\"confid\":2,\"max_inst\":10, \"min_inst\":1, \"usable\":70, \"inst_per_host\":1, \"itfc\":\"extractor.ver_1_0_0.ExtractorService\", \"method\":\"OnRecvMessage\"}, \
#             {\"name\":\"es-test-PE3\",\"confid\":3,\"max_inst\":10, \"min_inst\":1, \"usable\":70, \"inst_per_host\":1, \"itfc\":\"extractor.ver_1_0_0.ExtractorService\", \"method\":\"OnRecvMessage\"}]" \
#    -d topo_conf_file=ftp://cp01-rdqa-dev124.cp01/home/users/xxxxxx/project/es_topo/topo.conf \
#    -d es_fix_ratio="pe1:pe2:pe3=9.0:7.0:2.0"
#
# global : TIME_STAMP
function API_APP_register_es_app(){
    if [ "$#" -eq 1 ] && [ ! -z "${1}" ]; then
        es_app_name="${1}"
    else
        echo -e "Usage: ${COLOR_RED}[App name]\E[0m"
        return 1
    fi

    ssh "${DAG_TOPO_MACHINE}" "test -e ${DAG_TOPO_FILE_PATH}"
    if [ $? -ne 0 ]; then
        echo "Topo file ---> ${DAG_TOPO_MACHINE}:${DAG_TOPO_FILE_PATH} is not exist."
        return 1
    fi

    curl -X POST "http://${API_APP_MACHINE}/fs/register" \
        -d name="${es_app_name}" \
        -d creator="${CREATOR}" \
        -d admins="${SOFA_ADMINS}" \
        -d prod="${PROD}" \
        -d type="es" \
        -d token="${TOKEN}" \
        -d topo="[ \
                 {\"name\":\"rts-dag-app-lili-PE1-${TIME_STAMP}\",\"confid\":1,\"max_inst\":${ANTISPAM_INSTANCE_MAX}, \"min_inst\":${ANTISPAM_INSTANCE_MIN}, \"usable\":80, \"inst_per_host\":1, \"itfc\":\"ps.antispam.framework.ver_1_0_0.Antispam\", \"method\":\"run\"}, \
                 {\"name\":\"rts-dag-app-lili-PE2-${TIME_STAMP}\",\"confid\":2,\"max_inst\":${EXTRACTOR_INSTANCE_MAX}, \"min_inst\":${EXTRACTOR_INSTANCE_MIN}, \"usable\":80, \"inst_per_host\":1, \"itfc\":\"extractor.ver_1_0_0.ExtractorService\", \"method\":\"OnRecvMessage\"}]" \
    -d topo_conf_file="ftp://${DAG_TOPO_MACHINE}:${DAG_TOPO_FILE_PATH}" \
    -d es_fix_ratio="pe1:pe2=1.0:1.0"

    return "$?"
}


#curl -X POST "http://10.xx.xx.xx:xx/fs/imp" \
#  -d pretty=1 \
#  -d name=sofacloud-BUILD_RTS.${app_name} \
#  -d creator=wuxi01 \
#  -d version=ver_1_0_7 \
#  -d memory=1024 \
#  -d port='0' \
#  -d stub=1 \
#  -d cmd="cd bin %26%26 sh -x ./start.sh" \
#  -d src=ftp://xx.xx.xx.com/home/users/xx/bin/all.tar.gz
function API_JOB_deploy_job(){
    if [ "$#" -eq 3 ] && [ ! -z "${1}" ] && [ ! -z "${2}" ] && [ ! -z "${3}" ]; then
        app_type="${1}"
        app_name="${2}"
        tar_path="${3}"
    else
        echo -e "Usage: ${COLOR_RED} [App name] [parser.tar file Ftp path]\E[0m"
        return 1
    fi

    if [ ! -f "${tar_path}" ]; then
        echo -e "${COLOR_RED} Warning!\E[0m ${tar_path} file is not exist."
        return 255
    else
        tar_path="ftp://${SOFA_CLOUD_TAR_MAC}${tar_path}"
    fi

    case ${app_type} in
        cs) CMD="${PARSER_CMD}"
            MEM_USED="${PARSER_MEMORY}"
            ;;
        es1)
            CMD="${ANTISPAM_CMD}"
            MEM_USED="${ANTISPAM_MEMORY}"
            ;;
        es2)
            CMD="${EXTRACTOR_CMD}"
            MEM_USED="${EXTRACTOR_MEMORY}"
            ;;
        \?)  echo -e "App type is ${COLOR_RED} cs \E[0m or ${COLOR_RED} es \E[0m.";;
    esac

    curl -X POST "http://${API_APP_MACHINE}/fs/imp" \
      -d pretty=1 \
      -d name="${app_name}" \
      -d creator="${CREATOR}" \
      -d version="ver_1_0_0" \
      -d memory="${MEM_USED}" \
      -d port='0' \
      -d process_num='0' \
      -d stub=1 \
      -d cmd="${CMD}" \
      -d src="${tar_path}" \
      -d token="${TOKEN}"

    return "$?"
}

#API_ALIAS_show_alias
#API_ALIAS_change_alias "wbrts-parser-online-single" "sofacloud-BUILD_RTS.rtswb-parser-server-lili-050160123"
#API_ALIAS_change_alias "wbrts-parser-online" "sofacloud-BUILD_RTS.rtswb-parser-server-lili-050160123"
#API_ALIAS_change_alias "online-dag-single-20160516" "sofacloudes-BUILD_RTS.rts-dag-server-lili-05160125"

#API_APP_register_cs_app "rtswb-parser-server-lili-05100121"
#API_APP_register_es_app "rts-dag-server-lili-05170040"


# API_JOB_deploy_job "cs" "wiserts-parser-online-05311636" "${SOFA_CLOUD_TAR_PATH}/rts.parser.05302221.tar.gz"
# API_JOB_deploy_job "cs" "cserts-parser-online-201605302315" "${SOFA_CLOUD_TAR_PATH}/cse_dzy.tar.gz"
# API_JOB_deploy_job "cs" "${KUTYPE}-parser-online-${TIME_STAMP}" "${SOFA_CLOUD_TAR_PATH}/rts.parser.${TIME_STAMP}.tar.gz"
# API_JOB_deploy_job "es1" "rts-dag-app-lili-PE1-${TIME_STAMP}" "${SOFA_CLOUD_TAR_MAC}${SOFA_CLOUD_TAR_PATH}/"
# API_JOB_deploy_job "es2" "rts-dag-app-lili-PE2-${TIME_STAMP}" "${SOFA_CLOUD_TAR_MAC}${SOFA_CLOUD_TAR_PATH}/"

# API_APP_stop_app rtstb-parser-online-09181318
