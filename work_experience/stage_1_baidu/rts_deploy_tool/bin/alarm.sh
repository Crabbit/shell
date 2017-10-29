#########################################
# distributed build                     #
#                                       #
#                                       #
#                                       #
#                                       #
#                                       #
#########################################
#set -x

ALARM_DIR=`dirname $0`
#BIN_DIR="$DIR/../bin/"
#DATA_DIR="$DIR/../rts_env_for_rollback/"
#LOG_DIR="$DIR/../log/"
ALARM_STATUS_DIR="$ALARM_DIR/../status"

readonly HOSTNAME=`hostname`
readonly INDEX="[Unicorn Deploy]"

readonly EMAIL_LIST="xxxxxx"
readonly MOBILE_LIST="xxx"

readonly GSMSERVER="xxx"
readonly GSMPORT="xxx"

readonly HI_SERVER="http://xxx.xxx.com:xxx/talk"
readonly MSG_GROUP="xxx"
readonly HI_ROBOT="xxx"
readonly RICH_HI_CMD="curl -d 'msg=<msg>__HI_MSG__</msg>&to_group=${MSG_GROUP}&instance=${HI_ROBOT}&format=rich' ${HI_SERVER}"
readonly TEXT_HI_CMD="curl -d 'msg=__HI_MSG__&to_group=${MSG_GROUP}&instance=${HI_ROBOT}&format=text' ${HI_SERVER}"

#
# [Warning]-[Compass]-[Instance@yq01-build-client1.yq01]-[12_15-16:35:00]-[parser浠诲姟杩愯瓒呮椂]

#######################additianal config#########################
#FATAL $Msg
function send_hi_message(){

    local method="$1"
    local level="$2"
    local gran="$3"
    local gran_info="$4"
    local error_time="$5"
    local error_content="$6"

    message="[${level}]"
    message="${message}-${INDEX}"
    message="${message}-[${gran}@${gran_info}]"
    message="${message}-[${error_time}]"

    if [ "${method}" == "rich" ];then
        message="<text c=\"${message}%0d%0a\"/>"
        message="${message}${error_content}"
        SEND_HI_CMD=${RICH_HI_CMD/__HI_MSG__/"${message}"}
    else [ "${method}" == "text" ]
        message="${message}${error_content}"
        SEND_HI_CMD=${TEXT_HI_CMD/__HI_MSG__/"${message}"}
    fi

    bash -o pipefail -c "${SEND_HI_CMD}"
    
    #echo "${message}" >&2
    #echo "${message}" > ${ALARM_STATUS_DIR}/LAST_ERROR_INFO
    #echo "${message}" >> ${ALARM_STATUS_DIR}/ERROR_INFO
    return 0
}

function FATAL_NOTICE(){
    local error_content="$1"
    local error_time="$2"
    if [ -z "${error_time}" ];then
        error_time="`date +%m_%d-%H:%M:%S`"
    fi
    if [ -z "${error_content}" ];then
        error_content="`[Function:FATA_NOTICE error_content is null]`"
    fi
    send_hi_message rich NOTICE Instance "${HOSTNAME}" "${error_time}" "${error_content}"

    return 0
}

function FATAL_WARN(){
    local error_content="$1"
    local error_time="$2"
    if [ -z "${error_content}" ];then
        error_content="`[Function:FATA_NOTICE  error_content is null]`"
    fi
    if [ -z "${error_time}" ];then
        error_time="`date +%m_%d-%H:%M:%S`"
    fi
    send_hi_message text WARN Instance "${HOSTNAME}" "${error_time}" "${error_content}"

    exit 1
}

function FATAL() {
	echo "FATAL `date +"%F %T"` : $@" >&2
	INDEX_SUBJECT="[FATAL]$INDEX@$HOSTNAME : $@"
	INDEX_MESSAGE="[FATAL]$INDEX@$HOSTNAME : $@"
	SCRIPT_FULL_PATH=`readlink /proc/$$/fd/255`
	CUR_TIME=`date +"%F %T"`
	MAIL_CONTENT=`echo -e "Content:\n\t${@}\nHost:\n\t${HOSTNAME} \
			\nPath:\n\t${SCRIPT_FULL_PATH}\nTime:\n\t${CUR_TIME}"`
	echo "$MAIL_CONTENT" >&2
    echo "${MAIL_CONTENT}"  >${ALARM_STATUS_DIR}/ERROR_INFO
    echo "log_path ${HOSTNAME}:${LOG_DIR}" >>${ALARM_STATUS_DIR}/ERROR_INFO

	# 邮件报警详细说明情况
	ALARM_EMAIL "$INDEX_SUBJECT" "$MAIL_CONTENT"
	# 手机报警概要
	ALARM_MOBILE_LIST "$INDEX_SUBJECT"
    #监控报警，fatal不退出
	#exit 111;
}

function KPI_FATAL() {
	echo "FATAL `date +"%F %T"` : $@" >&2
	INDEX_SUBJECT="[KPI-FATAL]$INDEX@$HOSTNAME : $@"
	INDEX_MESSAGE="[KPI-FATAL]$INDEX@$HOSTNAME : $@"
	SCRIPT_FULL_PATH=`readlink /proc/$$/fd/255`
	CUR_TIME=`date +"%F %T"`
	MAIL_CONTENT=`echo -e "Content:\n\t${@}\nHost:\n\t${HOSTNAME} \
			\nPath:\n\t${SCRIPT_FULL_PATH}\nTime:\n\t${CUR_TIME}"`
	echo "$MAIL_CONTENT" >&2
    echo "${MAIL_CONTENT}"  >${ALARM_STATUS_DIR}/ERROR_INFO
    echo "log_path ${HOSTNAME}:${LOG_DIR}" >>${ALARM_STATUS_DIR}/ERROR_INFO

	# 邮件报警详细说明情况
	ALARM_EMAIL "$INDEX_SUBJECT" "$MAIL_CONTENT"
	# 手机报警概要
	ALARM_MOBILE_LIST "$INDEX_SUBJECT"
    #监控报警，fatal不退出
	#exit 111;
}

function FATAL_NOT_ALARM() {
	echo "FATAL `date +"%F %T"` : $@" >&2
	INDEX_SUBJECT="[FATAL]$INDEX@$HOSTNAME : $@"
	INDEX_MESSAGE="[FATAL]$INDEX@$HOSTNAME : $@"
	SCRIPT_FULL_PATH=`readlink /proc/$$/fd/255`
	CUR_TIME=`date +"%F %T"`
	MAIL_CONTENT=`echo -e "Content:\n\t${@}\nHost:\n\t${HOSTNAME} \
			\nPath:\n\t${SCRIPT_FULL_PATH}\nTime:\n\t${CUR_TIME}"`
	echo "$MAIL_CONTENT" >&2
	echo "${MAIL_CONTENT}"  >${ALARM_STATUS_DIR}/ERROR_INFO
    echo "log_path ${HOSTNAME}:${LOG_DIR}" 
    ALARM_EMAIL "$INDEX_SUBJECT" "$MAIL_CONTENT"
	exit 111;
}

#FATAL_NOT_EXIT $Msg
function FATAL_NOT_EXIT() {
	echo "FATAL `date +"%F %T"` : $@" >&2
	INDEX_SUBJECT="[FATAL]$INDEX@$HOSTNAME : $@"
	INDEX_MESSAGE="[FATAL]$INDEX@$HOSTNAME : $@"
	SCRIPT_FULL_PATH=`readlink /proc/$$/fd/255`
	CUR_TIME=`date +"%F %T"`
	MAIL_CONTENT=`echo -e "Content:\n\t${@}\nHost:\n\t${HOSTNAME} \
			\nPath:\n\t${SCRIPT_FULL_PATH}\nTime:\n\t${CUR_TIME}"`
	echo "$MAIL_CONTENT" >&2
	echo "${MAIL_CONTENT}"  >${ALARM_STATUS_DIR}/ERROR_NOTICE_INFO
    echo "log_path ${HOSTNAME}:${LOG_DIR}" >>${ALARM_STATUS_DIR}/ERROR_NOTICE_INFO
    # 邮件报警详细说明情况
	ALARM_EMAIL "$INDEX_SUBJECT" "$MAIL_CONTENT"
	# 手机报警概要
	ALARM_MOBILE_LIST "$INDEX_SUBJECT"
}

function FATAL_NOT_EXIT_NOT_ALARM() {
	echo "FATAL `date +"%F %T"` : $@" >&2
	INDEX_SUBJECT="[FATAL]$INDEX@$HOSTNAME : $@"
	INDEX_MESSAGE="[FATAL]$INDEX@$HOSTNAME : $@"
	SCRIPT_FULL_PATH=`readlink /proc/$$/fd/255`
	CUR_TIME=`date +"%F %T"`
	MAIL_CONTENT=`echo -e "Content:\n\t${@}\nHost:\n\t${HOSTNAME} \
			\nPath:\n\t${SCRIPT_FULL_PATH}\nTime:\n\t${CUR_TIME}"`
	echo "$MAIL_CONTENT" >&2
	ALARM_EMAIL "$INDEX_SUBJECT" "$MAIL_CONTENT"
}


#WARNING $Msg
function WARNING() {
	echo "WARNING `date +"%F %T"` : $@" >&2
}

#NOTICE $Msg
function NOTICE() {
	echo "NOTICE `date +"%F %T"` : $@" >&2
}

#check the return value
#CHK_RET $LEVEL $Msg
function CHK_RET() {
	ret=$?
	if [ $ret -ne 0 ]
	then
		$@
	fi
}

#报警函数
function CAT_EMAIL_LIST() {
        ELIST=""
        for i in $*
        do
                if [ -z $ELIST ]; then
                        ELIST=$i
                else
                        ELIST=$ELIST,$i
                fi
        done

        echo $ELIST
}
function ALARM_EMAIL() {
        if [ $# -ne 2 ]; then
                return 1
        fi

        ELIST="$(CAT_EMAIL_LIST $EMAIL_LIST)"
        echo "$2" | mail -s "$1" "$ELIST"
        return 0
}

function ALARM_MOBILE()	{
        if [ $# -ne 2 ]; then
                return 1
        fi

        #gsmsend -s $GSMSERVER:$GSMPORT "$1@$2"
        echo "sh -x /home/work/opbin/gsm/gsmsend_bl -s $GSMSERVER:$GSMPORT $1@$2"
        sh -x /home/work/opbin/gsm/gsmsend_bl -s $GSMSERVER:$GSMPORT "$1@$2" &>/home/work/opdir/lili/gsm.log
        if [ $? -ne 0 ]; then
                gsmsend -s $GSMSERVER:$GSMPORT "$1@Some problem happened, please check email"
                return 1
        else
                return 0
        fi
}

function ALARM_MOBILE_LIST() {
        if [ $# -ne 1 ]; then
                return 1;
        fi

        for i in $MOBILE_LIST
        do
                ALARM_MOBILE "$i" "$1"
        done
}
