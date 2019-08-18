#!/bin/sh
#
# start-master.sh
# Copyright (C) 2019 jack <jack@6k>
#
# Distributed under terms of the MIT license.
#

/spark/bin/spark-class org.apache.spark.deploy.master.Master \
    --ip $SPARK_LOCAL_IP \
    --port $SPARK_MASTER_PORT \
    --webui-port $SPARK_MASTER_WEBUI_PORT

