![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/qwertyjack/spark)
![Docker Pulls](https://img.shields.io/docker/pulls/qwertyjack/spark)
![Image Size](https://img.shields.io/docker/image-size/qwertyjack/spark/latest)
[![Docker Image CI & CD](https://github.com/QwertyJack/spark-cluster/actions/workflows/docker-image.yml/badge.svg)](https://github.com/QwertyJack/spark-cluster/actions/workflows/docker-image.yml)

# Spark Cluster

Deploy a local spark cluster using standalone mode[1].
Inspired by [2].

[1]: https://spark.apache.org/docs/latest/spark-standalone.html
[2]: https://towardsdatascience.com/a-journey-into-big-data-with-apache-spark-part-1-5dfcc2bccdd2

## Cluster Operation

- *(Optional)* Config shared storage to simulate HDFS: change `volumes` section in docker compose file (default: `/home`, `/data`)
- Start the cluster: `docker-compose up -d`
- *(Optional)* Visit `http://localhost:8080` in the browser to see the WebUI
- *(Optional)* Watch cluster logs: `docker-compose logs -f`
- *(Optional)* Add more workers (e.g. up to 3): `docker-compose up -d --scale spark-worker=3`
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

## Customize Python Environment

Thanks to shared folders, it is very easy to use your own Python environment in Spark.
Make sure your env is shared among the containers, i.e. `/home` or `/data` by default.

**Notes**: For compatibility issue py38 is not supported by Spark 2.4; **Python3.6 (pre-installed)** and Python3.7 are recommended.

To get an interactive shell:

```sh
docker exec -ti -w $PWD \
	-e PYSPARK_DRIVER_PYTHON=$(which ipython) \
	-e PYSPARK_PYTHON=$(which python) \
	spark-master pyspark --conf spark.executorEnv.PYTHONPATH=$PWD
```

Or to submit an app:

```sh
docker exec -w $PWD \
	-e PYSPARK_DRIVER_PYTHON=$(which python) \
	-e PYSPARK_PYTHON=$(which python) \
	spark-master spark-submit --conf spark.executorEnv.PYTHONPATH=$PWD my_app.py
```
