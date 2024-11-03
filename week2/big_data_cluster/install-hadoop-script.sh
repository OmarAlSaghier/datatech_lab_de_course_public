#!/bin/bash

# Currently:
#   step1 & 8: partially commented-out depending on the need

# Define variables
HADOOP_VERSION="3.2.4"
HADOOP_URL="https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"
HADOOP_INSTALL_DIR="/opt/hadoop"
HADOOP_USER=$(whoami)

# Step 0: Set up passwordless SSH
echo "Setting up passwordless SSH as a prerequisite..."
# Remove the comment from the below line if you already have a generated SSH key
# ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
ssh-keyscan -H localhost >> ~/.ssh/known_hosts

# Step 1: Create directory for Hadoop and download it
mkdir -p ~/hadoop_cluster 
cd ~/hadoop_cluster
echo "Downloading Hadoop..."
wget $HADOOP_URL

# Step 2: Extract Hadoop and move to /opt
echo "Extracting Hadoop..."
tar xzf hadoop-${HADOOP_VERSION}.tar.gz
sudo mv -f hadoop-${HADOOP_VERSION} /opt
sudo chown -R ${HADOOP_USER}:${HADOOP_USER} /opt/hadoop-${HADOOP_VERSION}
sudo ln -s /opt/hadoop-${HADOOP_VERSION} $HADOOP_INSTALL_DIR

# Step 3: Configure Hadoop core-site.xml
echo "Configuring core-site.xml..."
cat <<EOF | sudo tee /opt/hadoop/etc/hadoop/core-site.xml > /dev/null
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
EOF

# Step 4: Configure Hadoop hdfs-site.xml
echo "Configuring hdfs-site.xml..."
cat <<EOF | sudo tee /opt/hadoop/etc/hadoop/hdfs-site.xml > /dev/null
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
EOF

# Step 5: Set JAVA_HOME and Hadoop-related environment variables
JAVA_HOME_PATH="/usr/lib/jvm/java-1.8.0-openjdk-amd64"
echo "Setting up environment variables..."
echo "
# Java
export JAVA_HOME=${JAVA_HOME_PATH}
# Hadoop
export HADOOP_HOME=${HADOOP_INSTALL_DIR}
export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin
" >> ~/.bashrc
source ~/.bashrc

# Step 6: Update JAVA_HOME in hadoop-env.sh
echo "Configuring JAVA_HOME in hadoop-env.sh..."
sudo sed -i "/^#.*JAVA_HOME=.*/c\export JAVA_HOME=${JAVA_HOME_PATH}\nexport HADOOP_OS_TYPE=\${HADOOP_OS_TYPE:-\$(uname -s)}" /opt/hadoop/etc/hadoop/hadoop-env.sh

# Step 7: Format HDFS
echo "Formatting HDFS..."
hdfs namenode -format

# Step 8: Start HDFS
echo "Starting HDFS..."
start-dfs.sh

# Step 9: Verify HDFS components are running
echo "Verifying HDFS components..."
jps

# Step 10: Create user in HDFS
echo "Creating user directory in HDFS..."
hdfs dfs -mkdir -p /user/datatech-labs
hdfs dfs -ls /user/

# Step 11: Configure yarn-site.xml
echo "Configuring yarn-site.xml..."
cat <<EOF | sudo tee /opt/hadoop/etc/hadoop/yarn-site.xml > /dev/null
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
EOF

# Step 12: Configure mapred-site.xml
echo "Configuring mapred-site.xml..."
cat <<EOF | sudo tee /opt/hadoop/etc/hadoop/mapred-site.xml > /dev/null
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.application.classpath</name>
        <value>\$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:\$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>
    </property>
</configuration>
EOF

# Step 13: Start YARN
echo "Starting YARN..."
start-yarn.sh

# Step 14: Verify YARN components
echo "Verifying YARN components..."
jps

source ~/.bashrc

echo "Hadoop installation and setup complete!"

echo "You can verify the Hadoop services are running by visiting:"
echo "- HDFS Web UI: http://localhost:9870"
echo "- YARN Resource Manager: http://localhost:8088"
