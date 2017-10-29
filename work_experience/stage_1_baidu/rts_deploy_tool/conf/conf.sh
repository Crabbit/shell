#!/bin/bash
TIME_STAMP="$(date +%m%d%H%M)"

readonly VERSION="vers_`date +%Y`_`date +%m`_`date +%d`"

readonly LILI_TOKEN="xxxxxx"
readonly TOKEN=${LILI_TOKEN}

readonly MAIL_RECEIVER="xx@xx.com"
readonly MOBILE_RECEIVER="xx"
readonly SOURCE_LOCK="1"

readonly COLOR_RED='\E[31;40m'
readonly COLOR_GREEN='\E[1;32;40m'
readonly COLOR_YELLOW='\E[1;33;40m'
readonly COLOR_BLUE='\E[1;34;40m'
readonly COLOR_MAGENTA='\E[35;40m'
readonly COLOR_CYAN='\E[1;36;40m'

# alias api config
readonly API_APP_MACHINE="api.xx.xx.com:80"
#readonly API_ALIAS_MACHINE="xx.xx.x.xx:8888"
readonly API_ALIAS_MACHINE="xx.xx.xx.xx:8867/api/"
readonly ALIAS_USERNAME="xx"
readonly ALIAS_PASSWORD="xx"
readonly EXTRACTOR_ALIAS_NAME="online-dag-${TIME_STAMP}"

# sofa cloud env config
readonly SOFA_CLOUD_TAR_MAC="yq01-build-unicorn-clean0.yq01"
readonly SOFA_CLOUD_TAR_PATH="/home/work/sofacloud_tar_dir/"
readonly SOFA_ADMINS="xx.xx.xx.xx"
readonly CREATOR="xx"
readonly PROD="BUILD_RTS"

# parser clean env config
readonly PARSER_CLEAN_MAC="yq01-build-unicorn-clean0.yq01"
readonly PARSER_SEA_CONFIG_FILE="./newdbi/conf/vc_client.cn.conf"
readonly RTS_PARSER_CLEAN="/home/work/clean/rts_clean/"
readonly RTS_PARSER_NO_ANTI_CLEAN="/home/work/clean/rts_clean_no_anti/"
readonly PARSER_NO_ANRI_CONFIG_FILE="./newdbi/conf/parser.conf"
readonly RTSWB_PARSER_CLEAN="/home/work/clean/wbrts_clean/"
readonly RTSTB_PARSER_CLEAN="/home/work/clean/tbrts_clean/"
readonly CSERTS_PARSER_CLEAN="/home/work/clean/cserts_clean/"
readonly WISERTS_PARSER_CLEAN="/home/work/clean/rts_clean/"

# extractor clean env config
readonly EXTRACTOR_CLEAN_MAC="yq01-build-unicorn-clean0.yq01"
readonly EXTRACTOR_CLEAN_PATH="/home/work/extractor"


# antispam clean env config
readonly ANTISPAM_CLEAN_MAC="yq01-build-unicorn-clean0.yq01"
readonly ANTISPAM_CLEAN_PATH="/home/work/antispamserv"

# parser job config
readonly RTS_PARSER_INSTANCE_MIN="82"
readonly RTS_PARSER_INSTANCE_MAX="82"
readonly RTSWB_PARSER_INSTANCE_MIN="14"
readonly RTSWB_PARSER_INSTANCE_MAX="14"
readonly RTSTB_PARSER_INSTANCE_MIN="13"
readonly RTSTB_PARSER_INSTANCE_MAX="13"
readonly CSERTS_PARSER_INSTANCE_MIN="8"
readonly CSERTS_PARSER_INSTANCE_MAX="8"
readonly WISERTS_PARSER_INSTANCE_MIN="8"
readonly WISERTS_PARSER_INSTANCE_MAX="8"
readonly USABLE=75
readonly INSTANCE_PER_HOST="1"
readonly PARSER_MEMORY="2048"
readonly PARSER_CMD="./pserver -c pserver.xml"


# dag config
readonly DAG_TOPO_MACHINE="yq01-build-unicorn-clean0.yq01"
readonly DAG_TOPO_FILE_PATH="/home/work/extractor/topo.conf"

# antispam job config
readonly ANTISPAM_INSTANCE_MIN="82"
readonly ANTISPAM_INSTANCE_MAX="82"
readonly ANTISPAM_MEMORY="8192"
readonly ANTISPAM_CMD=""

# extractor job config
readonly EXTRACTOR_INSTANCE_MIN="82"
readonly EXTRACTOR_INSTANCE_MAX="82"
readonly EXTRACTOR_MEMORY="18432"
readonly EXTRACTOR_CMD=""
