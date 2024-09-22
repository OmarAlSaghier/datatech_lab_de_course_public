# Setup and Install Apache Kafka

* Download Kafka in `~/hadoop_cluster` folder:
```
wget https://downloads.apache.org/kafka/3.3.1/kafka-3.3.1-src.tgz
```

* Unzip kafka file
```
tar xzf kafka-3.3.1-src.tgz
```

* Move the unzipped folder to `/opt` directory
```
sudo mv -f <kafka_unzipped_folder> /opt/
```

* Create soft link (Alias name)
```
cd /opt/
sudo ln -s kafka-3.3.1-src/ kafka
```

* Add this section to your `.bashrc` file
```
# Kafka
export KAFKA_HOME=/opt/kafka
export PATH=$PATH:${KAFKA_HOME}/bin
```

* Reload `.bashrc`
```
source .bashrc
```

* Start Zookeeper service (And keep it running in a separate terminal) with giving an argument as `zookeeper.properties` file
```
zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties
```

* **Open Another terminal** and start Kafka service (And keep it running in a separate terminal) with giving an argument as `server.properties` file
```
kafka-server-start.sh /opt/kafka/config/server.properties
```


* Create a kafka topic called `first-topic`
```
kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic first-topic
```

* List the topics
```
kafka-topics.sh --list --bootstrap-server localhost:9092
```

***
* Might need the command in case of the below jar file missing:
```
cd /opt/kafka/
./gradlew jar -PscalaVersion=2.13.8
```
