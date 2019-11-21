#!/bin/bash

# hadoop/bin/hdfs dfs -put /root/spark/data/mllib/sample_libsvm_data.txt /data.txt
            # /root/spark/bin/spark-submit --master ${SPARK_MASTER2} /root/tasks/tree.py
    #sleep infinity
    /root/spark/bin/spark-submit --master spark://${SPARK_MASTER} /root/spark/examples/src/main/python/pi.py


