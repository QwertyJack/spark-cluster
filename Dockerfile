FROM openjdk:8-alpine

ARG SPARK_VERSION=2.4.3
ARG HADOOP_VERSION=2.7

RUN wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
 && tar xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C / \
 && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
 && ln -s /spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /spark

RUN apk add bash coreutils procps python py-pip \
 && pip install ipython

ENV PYSPARK_DRIVER_PYTHON ipython

WORKDIR /spark
