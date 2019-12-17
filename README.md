![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/mienkofax/spark-cluster)
![Docker Pulls](https://img.shields.io/docker/pulls/mienkofax/spark-cluster)
![Image Size](https://img.shields.io/microbadger/image-size/mienkofax/spark-cluster/latest)

# Spark Cluster

Deploy a local spark cluster using standalone mode[1].
Inspired by [2] and [3]

[1]: https://spark.apache.org/docs/latest/spark-standalone.html
[2]: https://towardsdatascience.com/a-journey-into-big-data-with-apache-spark-part-1-5dfcc2bccdd2
[3]: https://github.com/QwertyJack/spark-cluster

## Cluster Operation

- Using Docker hub:
    - Start the cluster with pi example: `docker-compose -f docker-compose.yml -f docker-compose.pull.yml up -d`
    - Start the cluster without example: `docker-compose -f docker-compose.yml -f docker-compose.pull.yml up -d nodemaster node2 node3`
    - *(Optional)* start task with pi example: `docker-compose -f docker-compose.yml -f docker-compose.pull.yml up task`
- Using local Dockerfile:
    - Start the cluster with pi example: `docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d`
    - Start the cluster without example: `docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d nodemaster node2 node3`
    - *(Optional)* start task with pi example `docker-compose -f docker-compose.yml -f docker-compose.build.yml up task`
- *(Optional)* Visit `http://172.0.0.10:8080` in the browser to see the master WebUI
- *(Optional)* Visit `http://172.0.0.10:9870` in the browser to see the Hadoop UI
- *(Optional)* Visit `http://172.0.0.10:18080` in the browser to see the Spark History Server
- *(Optional)* Watch cluster logs: `docker-compose logs -f`
- *(Optional)* Watch cluster resource usage in real time: `docker stats`
- Shutdown the cluster and clean up: `docker-compose down`

## Run Application

### Using interactive shell, i.e. *pyspark*

```sh
$ docker exec -it spark-master bin/pyspark --master spark://spark-master:7077
...
>>> from random import random
>>> def sample(_):
...   x, y = random(), random()
...   return x*x + y*y < 1
...
>>> count = 1000000
>>> 4.0 * sc.parallelize(range(count)).filter(sample).count() / count
```

### Submit app to the cluster

```sh
# run java app
docker exec spark-master bin/spark-submit --master spark://spark-master:7077 --class org.apache.spark.examples.SparkPi examples/jars/spark-examples_2.11-2.4.3.jar 1000

# run python app
docker exec spark-master bin/spark-submit --master spark://spark-master:7077 examples/src/main/python/pi.py 1000
```
