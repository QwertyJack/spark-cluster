FROM ubuntu

ARG SPARK_VERSION=2.4.3
ARG HADOOP_VERSION=2.7

RUN apt update -qq \
 && apt install -y -qq --no-install-recommends wget openjdk-8-jdk-headless ipython3 vim curl \
 && rm -rf /var/lib/apt/list/*

RUN wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
 && tar xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C / \
 && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
 && ln -s /spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /spark

RUN ln -s python3 /usr/bin/python

ENV PYSPARK_DRIVER_PYTHON=ipython3 PYSPARK_PYTHON=python3 PYTHONIOENCODING=utf8

WORKDIR /spark
