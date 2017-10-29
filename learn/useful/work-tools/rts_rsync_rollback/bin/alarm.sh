#########################################
# distributed build                     #
#                                       #
#                                       #
#                                       #
#                                       #
#                                       #
#########################################
DIR=`dirname $0`
BIN_DIR="$DIR/../bin/"
DATA_DIR="$DIR/../rts_env_for_rollback/"
LOG_DIR="$DIR/../log/"
STATUS_DIR="$DIR/../status"

HOSTNAME=`hostname`
INDEX="RTS_RSYNC_ENV"

EMAIL_LIST="lili36@baidu.com"
MOBILE_LIST="18729382082"

GSMSERVER="emp01.baidu.com"
GSMPORT="15001"


#######################additianal config#########################
#FATAL $Msg
function FATAL() {
	echo "FATAL `date +"%F %T"` : $@" >&2
	INDEX_SUBJECT="[FATAL]$INDEX@$HOSTNAME : $@"
	INDEX_MESSAGE="[FATAL]$INDEX@$HOSTNAME : $@"
	SCRIPT_FULL_PATH=`readlink /proc/$$/fd/255`
	CUR_TIME=`date +"%F %T"`
	MAIL_CONTENT=`echo -e "Content:\n\t${@}\nHost:\n\t${HOSTNAME} \
			\nPath:\n\t${SCRIPT_FULL_PATH}\nTime:\n\t${CUR_TIME}"`
	echo "$MAIL_CONTENT" >&2
    echo "${MAIL_CONTENT}"  >${STATUS_DIR}/ERROR_INFO
    echo "log_path ${HOSTNAME}:${LOG_DIR}" >>${STATUS_DIR}/ERROR_INFO

	# 邮件报警详细说明情况
	ALARM_EMAIL "$INDEX_SUBJECT" "$MAIL_CONTENT"
	# 手机报警概要
	ALARM_MOBILE_LIST "$INDEX_SUBJECT"
	exit 111;
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
	echo "${MAIL_CONTENT}"  >${STATUS_DIR}/ERROR_INFO
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
	echo "${MAIL_CONTENT}"  >${STATUS_DIR}/ERROR_NOTICE_INFO
    echo "log_path ${HOSTNAME}:${LOG_DIR}" >>${STATUS_DIR}/ERROR_NOTICE_INFO
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

        gsmsend -s $GSMSERVER:$GSMPORT "$1@$2"
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
