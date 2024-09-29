# SPARK Installation on Ubuntu


* Download Spark3 in `~/hadoop_cluster` folder:
```
$ wget https://dlcdn.apache.org/spark/spark-3.2.3/spark-3.2.3-bin-hadoop3.2.tgz
```

* Untar using the following command
```
$ cd ~/hadoop_cluster
$ tar xzf spark-3.2.3-bin-hadoop3.2.tgz
```

* Move to `/opt` directory:
```
$ sudo mv -f spark-3.2.3-bin-hadoop3.2 /opt
$ sudo ln -s spark-3.2.3-bin-hadoop3.2 /opt/spark
```

* Update `/opt/spark/conf/spark-env.sh` with below environment variables.
```
export HADOOP_HOME="/opt/hadoop"
export HADOOP_CONF_DIR="/opt/hadoop/etc/hadoop"
export SPARK_DIST_CLASSPATH=$(hadoop --config ${HADOOP_CONF_DIR} classpath)
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_HOME/lib/native
```

* Update `/opt/spark/conf/spark-defaults.conf` with below properties.
```
spark.driver.extraJavaOptions -Dderby.system.home=/tmp/derby/
spark.sql.repl.eagerEval.enabled   true
spark.master    yarn
spark.eventLog.enabled true
spark.eventLog.dir               hdfs:///spark-logs
spark.history.provider            org.apache.spark.deploy.history.FsHistoryProvider
spark.history.fs.logDirectory     hdfs:///spark-logs
spark.history.fs.update.interval  10s
spark.history.ui.port             18081
spark.yarn.historyServer.address localhost:18081
spark.yarn.jars hdfs:///spark-jars/*.jar
```

* We also need to create directories for logs and jars in HDFS. Also, Spark jars should be copied to HDFS folder.
```
$ hdfs dfs -mkdir /spark-jars
$ hdfs dfs -mkdir /spark-logs
$ hdfs dfs -put /opt/spark/jars/* /spark-jars
```

* Validate starting Spark using Scala by running:
```
$ /opt/spark/bin/spark-shell --master yarn --conf spark.ui.port=0
```

* Validate starting Spark using Python by running:
```
$ /opt/spark/bin/pyspark --master yarn --conf spark.ui.port=0
```

* Add PYSPARK_PYTHON and SPARK_HOME to `~/bashrc`:
```
# Spark
export PYSPARK_PYTHON=python3
export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
```

************************************
### HIVE Integrtion Section 

By default we will not be able to access Hive Metastore tables and databases using Spark. We need to perform below steps to integrate Spark with Hive Metastore.

* Create soft link for `hive-site.xml` in Spark conf folder.
```
$ sudo ln -s /opt/hive/conf/hive-site.xml /opt/spark/conf/
```

* We also need to install latest Postgres JDBC jar in Spark jars folder.
```
$ sudo wget https://jdbc.postgresql.org/download/postgresql-42.2.19.jar \
    -O /opt/spark/jars/postgresql-42.2.19.jar
```

* Validate hive connection in pyspark
```
$ spark.sql('SHOW databases').show()
```

* For Spark3, Update `/opt/hive/conf/hive-site.xml` with below setting.
```
  <property>
    <name>hive.metastore.schema.verification</name>
    <value>false</value>
  </property>
```
************************************
