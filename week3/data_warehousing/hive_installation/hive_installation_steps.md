# Apache Hive Installation

* Download Hive mirror image
```
wget https://apache.osuosl.org/hive/hive-4.0.1/apache-hive-4.0.1-bin.tar.gz
OR
wget https://dlcdn.apache.org/hive/hive-4.0.1/apache-hive-4.0.1-bin.tar.gz
```

* Untar the downloaded file
```
tar xzf apache-hive-4.0.1-bin.tar.gz
```

* Move Hive directory to /opt and create the soft link name
```
sudo mv -f apache-hive-4.0.1-bin /opt
cd /opt/
sudo ln -s apache-hive-4.0.1-bin hive
```

* Add hive directory to `.bashrc` file
```
export HIVE_HOME=/opt/hive
export PATH=$PATH:${HIVE_HOME}/bin
```

* Copy the `hive-site.xml` file given in the instructions in this repo under (`./hive-site.xml`) 
to the Hive conf directory:
```
$ cd /opt/hive/conf/
$ cp Data_warehousing_in_hadoop/installation/hive-site.xml /opt/hive/conf/
```

* Make HDFS directories and amend proper permission
```
hdfs dfs -mkdir /user/hive/warehouse
hdfs dfs -mkdir /user/tmp

hdfs dfs -chmod g+w /user/tmp
hdfs dfs -chmod g+w /user/hive/warehouse
```

* Now, We also need to overwrite guava jar in the hive lib folder with the one from Hadoop libraries.
```
$ rm /opt/hive/lib/guava-19.0.jar  # might have different version

$ cp /opt/hadoop/share/hadoop/hdfs/lib/guava-27.0-jre.jar /opt/hive/lib/
```

***
## Hive Metastore
Here we will be setting up the postgres database to hold hive metadata:

* Make sure the user is member of docker group. If the user is just added, make sure to restart the session (exit and relogin using SSH).
```
id ${USER}
sudo usermod -aG docker ${USER}
```

* Use below commands to setup fresh postgres database. It is named as cluster_util_db as we will be using the same database for other utilities as well.
```
$ docker pull postgres  # If image does not exist in docker
 
$ docker create \
    --name hive_meta_store_db \
    -p 5432:5432 \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres \
    -v ~/apps/postgres_hms/data:/var/lib/postgresql/data \
    postgres
 
$ docker start hive_meta_store_db
```

* You can check the logs of the created container:
```
docker logs -f hive_meta_store_db  # Use Ctrl+C to come out of the logs
```

* Let us create a database named "metastore" for Hive Metastore using Postgres Database container just created. First we need to access inside the container and access postgres client "psql" inside it with one command as:
```
docker exec \
  -it hive_meta_store_db \
  psql -U postgres
```

* Then create the required database and roles inside the "psql". You can then list the databases and quit "psql"
```
$ CREATE DATABASE metastore;
$ CREATE USER hive WITH ENCRYPTED PASSWORD 'hive';
$ GRANT ALL ON DATABASE metastore TO hive;
 
$ \l  # To list databases
$ \q  # To quit psql interface
```


* Inside the postgres container, modify "pg_hba.conf" file by changing the same file in the attached volume
in the container:
modify "pg_hba.conf" at: `/var/lib/postgresql/data/pg_hba.conf`
or local: `apps/postgres_hms/data/pg_hba.conf`
the line of:

```
# IPv4 local connections:
host    all             all             0.0.0.0/0               trust
```

* After the changes you have to reload the configuration. One way to do this is execute this SELECT as a superuser.
```
SELECT pg_reload_conf();
```

## After the Metastore database is set up
* Now we should be able to initialize Hive Metastore Database using Postgres, and create the metadata tables and data with the command:
```
schematool -initSchema -dbType postgres
```

***
## **Spark Integration with Hive** 

By default we will not be able to access Hive Metastore tables and databases using Spark. We need to perform below steps to integrate Spark with Hive Metastore.

* Create soft link for hive-site.xml in Spark conf folder.
```
sudo ln -s /opt/hive/conf/hive-site.xml /opt/spark/conf/
```

* We also need to install latest Postgres JDBC jar in Spark jars folder.
```
sudo wget https://jdbc.postgresql.org/download/postgresql-42.2.19.jar \
    -O /opt/spark/jars/postgresql-42.2.19.jar
```

* Validate Hive connection in pyspark-shell by
```
spark.sql('SHOW databases').show()
```

* To change Spark log-level, access with `/opt/spark/conf` directory, remove the `.template` from the file `log4j.properties.template` and change:
```
# This line:
log4j.rootCategory=INFO, console

# To This line:
log4j.rootCategory=ERROR, console
```

***

## **Launch and Validate Hive:**
Now, we can launch Hive and access HiveQL CLI:
```
hive
```