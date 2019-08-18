#!/bin/sh
#
# start-worker.sh
# Copyright (C) 2019 jack <jack@6k>
#
# Distributed under terms of the MIT license.
#

/spark/bin/spark-class org.apache.spark.deploy.worker.Worker \
    --webui-port $SPARK_WORKER_WEBUI_PORT \
    $SPARK_MASTER

