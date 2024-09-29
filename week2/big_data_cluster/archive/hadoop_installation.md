# HADOOP Installation on Ubuntu

### Prerequistes

1. Install and verify java
```
$ sudo apt-get install openjdk-8-jdk -y
$ java -version
```

2. Check if there are previously generated ssh-keys
```
$ ls -ltr .ssh/
```

* We need to setup a passwordless login using ssh keys. Generate ssh keys if not found, and append them to authorized keys
```
$ ssh-keygen
$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

* If failed, try to uninstall and install ssh agent again using:
```
$ sudo apt-get remove openssh-client openssh-server
$ sudo apt-get install openssh-client openssh-server
```


### Download and install hadoop

* Preferrably, make a new folder the tar files:
```
$ mkdir ~/hadoop_cluster
$ cd ~/hadoop_cluster
```

* Download Hadoop image
```
$ wget https://dlcdn.apache.org/hadoop/common/hadoop-3.2.4/hadoop-3.2.4.tar.gz
```

* Untar using the following command
```
$ tar xzf hadoop-3.2.4.tar.gz
```

* Move the folder to `/opt`, create soft link by name `/opt/hadoop` and also change the ownership of the folder to the user we have used for login.
```
$ sudo mv -f hadoop-3.2.4 /opt
$ sudo chown ${USER}:${USER} -R /opt/hadoop-3.2.4
$ sudo ln -s /opt/hadoop-3.2.4 /opt/hadoop
```

* Put the below content in file: `/opt/hadoop/etc/hadoop/core-site.xml`.
```
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
```


* Put the below content in file: `/opt/hadoop/etc/hadoop/hdfs-site.xml`.
```
<configuration>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/opt/hadoop/dfs/name</value>
    </property>
    <property>
        <name>dfs.namenode.checkpoint.dir</name>
        <value>/opt/hadoop/dfs/namesecondary</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/opt/hadoop/dfs/data</value>
    </property>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
```

* Validate the JDK location to set `JAVA_HOME`
```
$ ls -ltr /usr/lib/jvm/java-1.8.0-openjdk-amd64
```

* Setup environment variables under `.bashrc`, 
Append below export statements to existing `.bashrc`. 
Make sure to restart the session once profile is updated.
```
# Java
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
# Hadoop
export HADOOP_HOME=/opt/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
```

* Update `JAVA_HOME` in `/opt/hadoop/etc/hadoop/hadoop-env.sh` with the below content:
```
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export HADOOP_OS_TYPE=${HADOOP_OS_TYPE:-$(uname -s)}
```

* Format HDFS so that directories for Namenode, Secondary Namenode as well as Datanode are created.
```
$ hdfs namenode -format
$ ls -ltr /opt/hadoop/dfs/
```

* We need to have password less login setup with in the server using the same user who owns `/opt/hadoop` folder.
```
$ ssh ${USER}@localhost
```

* Start HDFS components using `start-dfs.sh` command file.
```
$ start-dfs.sh
```

* Run `jps` command to ensure Namenode, Secondary Namenode and Datanode are running.
```
$ jps
```

* Validate HDFS and create user using:
```
$ hdfs dfs -mkdir -p /user/zaka
$ hdfs dfs -ls /user/
```


### Configuring YARN: 

* Put the below content in file: `/opt/hadoop/etc/hadoop/yarn-site.xml`
```
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
    </property>
</configuration>
```

* Put the below content in file: `/opt/hadoop/etc/hadoop/mapred-site.xml`
```
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.application.classpath</name>
        <value>$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>
    </property>
</configuration>
```

* Start YARN components using `start-yarn.sh`.
```
$ start-yarn.sh
```

* Run jps command to ensure resource manager and node manager are running as daemons
```
$ jps
```


### Shutting down (when needed):
* Make sure yarn is stopped by the command:
```
$ stop-yarn.sh
```

* Make sure HDFS is stopped by the command:
```
$ stop-hdfs.sh
```