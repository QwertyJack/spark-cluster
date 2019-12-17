from openjdk:8

ENV HDFS_DATANODE_USER="root"
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_NODEMANAGER_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"


ENV JAVA_HOME=/usr/local/openjdk-8
ARG JAVA_HOME_DOCKER="JAVA_HOME=${JAVA_HOME}"

EXPOSE 22
EXPOSE 4040
EXPOSE 7077
EXPOSE 8080
EXPOSE 8081
EXPOSE 8088
EXPOSE 9870
EXPOSE 18080

USER root

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install openssh-server python-numpy python3 python3-pip rsync -y --no-install-recommends&& \
    apt-get clean


# Scala setup
WORKDIR /tmp
RUN wget https://downloads.lightbend.com/scala/2.12.10/scala-2.12.10.tgz && \
    tar xzf scala-2.12.10.tgz && \
    mv scala-2.12.10 /usr/share/scala && \
    ln -s /usr/share/scala/bin/* /usr/bin && \
    rm scala-2.12.10.tgz


# Spark setup
WORKDIR /root
RUN wget https://archive.apache.org/dist/hadoop/core/hadoop-3.2.1/hadoop-3.2.1.tar.gz
RUN wget https://archive.apache.org/dist/spark/spark-3.0.0-preview/spark-3.0.0-preview-bin-without-hadoop.tgz

RUN tar -zxf hadoop-3.2.1.tar.gz && \
    mv hadoop-3.2.1 hadoop && \
    tar -zxf spark-3.0.0-preview-bin-without-hadoop.tgz && \
    mv spark-3.0.0-preview-bin-without-hadoop spark && \
    rm *gz
RUN mkdir -p /root/.ssh /root/hadoop/logs \
    /root/data/nameNode /root/data/dataNode \
    /root/data/namesecondary /root/data/tmp && \
    touch /root/hadoop/logs/fairscheduler-statedump.log


# SSH setup
WORKDIR /tmp
RUN echo "pas" | ssh-keygen -t rsa -P '' -f /tmp/id_rsa && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/ssh_config && \
    echo "Host *" >> /etc/ssh/ssh_config && \
    cp /tmp/id_rsa* /root/.ssh/ && \
    cp /tmp/id_rsa.pub /root/.ssh/authorized_keys && \
    rm /tmp/id_rsa* && \
    chmod 600 /root/.ssh/id_rsa

COPY config/shellrc /root/.bashrc
COPY config/shellrc /root/.profile
COPY entrypoint.sh /root/entrypoint.sh
COPY tasks /root/tasks
COPY config/workers /root/spark/conf/slaves
COPY config/spark-defaults.conf /root/spark/conf/
COPY config/core-site.xml config/hdfs-site.xml config/mapred-site.xml \
    config/yarn-site.xml config/workers /root/hadoop/etc/hadoop/

RUN echo $JAVA_HOME_DOCKER >> /root/hadoop/etc/hadoop/hadoop-env.sh
RUN mkdir /loggs

WORKDIR /root/
ENTRYPOINT ["/bin/bash", "/root/entrypoint.sh"]
