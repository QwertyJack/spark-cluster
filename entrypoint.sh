#!/bin/bash
export PATH=/root/hadoop/bin:/root/hadoop/sbin:/root/spark/bin:$PATH
export HADOOP_HOME=/root/hadoop
export LD_LIBRARY_PATH=/root/hadoop/lib/native:$LD_LIBRARY_PATH
export HADOOP_CONF_DIR=/root/hadoop/etc/hadoop
export SPARK_DIST_CLASSPATH=$(hadoop classpath)
export SPARK_HOME=/root/spark
export JAVA_HOME=/usr/local/openjdk-8
export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root

function wait_for_endpoint() {
    until $(curl --output /dev/null --silent --head --fail ${1}); do
        echo "Waiting for ${1}"
        sleep 5
    done
}

function init_container() {
    if [ ! -f "/formated" ]; then
        hadoop/bin/hdfs namenode -format
        touch /formated
    fi
}

function init_directory() {
    if [ ! -f "/log_dir" ]; then
        hdfs dfs -mkdir /spark-log
        hdfs dfs -chmod 777 /spark-log
        hdfs dfs -chown spark:spark /spark-log
    fi
}

pip3 --no-cache-dir install -r /root/tasks/requirements.txt
pip3 --no-cache-dir install /root/package/dga.tar.gz

for arg in "$@"
do
    case $arg in
        "master" )
            service ssh start

            init_container

            echo ">>>>> Starting hdfs ..."
            hadoop/sbin/start-dfs.sh

            echo ">>>>> Starting yarn ..."
            hadoop/sbin/start-yarn.sh

            echo ">>>>> Starting Spark history server"
            init_directory
            /root/spark/sbin/start-history-server.sh

            echo ">> Starting Spark master ..."
            /root/spark/sbin/start-master.sh
            tail -f /root/spark/logs/*

            sleep infinity
            ;;
        "node" )
            service ssh start

            wait_for_endpoint http://nodemaster:8080
            wait_for_endpoint http://nodemaster:9870

            echo ">> Starting Spark slave ..."
            /root/spark/sbin/start-slave.sh ${SPARK_MASTER}
            tail -f /root/spark/logs/*

            sleep infinity
            ;;
        "task" )
            wait_for_endpoint http://nodemaster:8080
            wait_for_endpoint http://nodemaster:9870

            bash /root/tasks/run_tasks.sh
            ;;
        *)
            ;;
   esac
done
