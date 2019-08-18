![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/qwertyjack/spark)
![Docker Pulls](https://img.shields.io/docker/pulls/qwertyjack/spark)
![Image Size](https://img.shields.io/microbadger/image-size/qwertyjack/spark/latest)

# Spark Cluster

Deploy a local spark cluster using standalone mode[1].
Inspired by [2].

[1]: https://spark.apache.org/docs/latest/spark-standalone.html
[2]: https://towardsdatascience.com/a-journey-into-big-data-with-apache-spark-part-1-5dfcc2bccdd2

## Cluster Operation

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
