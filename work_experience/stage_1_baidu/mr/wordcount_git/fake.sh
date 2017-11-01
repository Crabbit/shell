#! /bin/sh
#HADOOP_CMD="/home/work/hadoop-client/hadoop/bin/hadoop"
HADOOP_CMD="/home/work/opdir/lili/tool/bin/wordcount/hadoop_afs/hadoop/bin/hadoop"
INPUT_DIR="/user/build/app/lili/wordcount/input*/"
OUTPUT_DIR="/user/build/app/lili/wordcount/output"

#UGI="build,dwbT1JJ50"
UGI="build,0cd1c832"
#QUEUE="build_week"
QUEUE="buffer_gzhxy"
#HADOOP_SITE="./hadoop-site.xml.yq01_build"
HADOOP_SITE="hadoop-site.xml.gzns_kunpeng"

demo_file="./input/txt.*"
#${HADOOP_CMD} dfs -conf ${HADOOP_SITE} -put ${demo_file} "${INPUT_DIR}"

${HADOOP_CMD} dfs -conf ${HADOOP_SITE} -rmr ${OUTPUT_DIR}

${HADOOP_CMD} streaming -conf ${HADOOP_SITE} -Dhadoop.job.ugi=${UGI} -Dmapred.job.queue.name=${QUEUE} -Dmapred.job.groups=${QUEUE} \
     -jobconf mapred.job.name="lili_streaming_wordcount" \
     -jobconf mapred.map.tasks=2000 \
     -jobconf mapred.reduce.tasks=100 \
     -jobconf mapred.job.map.capacity=5000 \
     -jobconf stream.memory.limit=50 \
     -input ${INPUT_DIR}/* \
     -output ${OUTPUT_DIR}/output  \
     -file ./wc_mapper.sh \
     -file ./wc_reducer.sh \
     -mapper "sh wc_mapper.sh" \
     -reducer "sh wc_reducer.sh"
