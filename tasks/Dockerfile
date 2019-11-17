FROM mienkofax/spark-cluster:v-0.3

ENV SPARK_MASTER_URL="spark://spark-master:7077"
ENV SPARK_SUBMIT_ARGS=""
ENV SPARK_APPLICATION_ARGS ""

COPY . /tasks
WORKDIR /tasks

CMD ["/bin/bash", "run_tasks.sh"]
