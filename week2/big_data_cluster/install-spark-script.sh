#!/bin/bash

# Define variables
SPARK_VERSION="3.5.3"
HADOOP_VERSION="3"
INSTALL_DIR="/opt"
HADOOP_HOME="/opt/hadoop"
SPARK_HOME="/opt/spark"
SPARK_CONF_DIR="$SPARK_HOME/conf"
HADOOP_CONF_DIR="$HADOOP_HOME/etc/hadoop"
USER_HOME=$(eval echo ~$USER)

# Step 1: Create the Hadoop cluster directory if it doesn't exist
echo "Creating ~/hadoop_cluster directory if it doesn't exist..."
mkdir -p ~/hadoop_cluster
cd ~/hadoop_cluster

# Step 2: Download Spark
echo "Downloading Spark $SPARK_VERSION..."
wget -q "https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

# Step 3: Extract Spark tarball
echo "Extracting Spark..."
tar xzf "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

# Step 4: Move Spark to /opt and create a symbolic link
echo "Moving Spark to $INSTALL_DIR and creating symbolic link..."
sudo mv -f "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" $INSTALL_DIR
sudo ln -sf "${INSTALL_DIR}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" $SPARK_HOME

# Step 5: Update spark-env.sh
echo "Configuring spark-env.sh..."
cat <<EOL | sudo tee $SPARK_CONF_DIR/spark-env.sh
export HADOOP_HOME="$HADOOP_HOME"
export HADOOP_CONF_DIR="$HADOOP_CONF_DIR"
export SPARK_DIST_CLASSPATH=\$(hadoop --config \${HADOOP_CONF_DIR} classpath)
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$HADOOP_HOME/lib/native
EOL
sudo chmod +x $SPARK_CONF_DIR/spark-env.sh

# Step 6: Update spark-defaults.conf
echo "Configuring spark-defaults.conf..."
cat <<EOL | sudo tee $SPARK_CONF_DIR/spark-defaults.conf
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
EOL

# Step 7: Create directories in HDFS and upload Spark jars
echo "Creating HDFS directories and uploading Spark jars..."
hdfs dfs -mkdir -p /spark-jars
hdfs dfs -mkdir -p /spark-logs
hdfs dfs -put $SPARK_HOME/jars/* /spark-jars

# Step 8: Update .bashrc with Spark environment variables
echo "Updating .bashrc with Spark environment variables..."
cat <<EOL >> $USER_HOME/.bashrc

# Spark
export PYSPARK_PYTHON=python3
export SPARK_HOME=$SPARK_HOME
export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin
EOL

# Source .bashrc to apply changes to the current session
source $USER_HOME/.bashrc

echo "Spark installation and configuration complete."
echo "Validate by running '/opt/spark/bin/spark-shell --master yarn --conf spark.ui.port=0' or '/opt/spark/bin/pyspark --master yarn --conf spark.ui.port=0'."
