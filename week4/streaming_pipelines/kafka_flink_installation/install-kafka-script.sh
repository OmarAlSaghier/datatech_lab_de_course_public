#!/bin/bash

# Variables
KAFKA_VERSION="3.3.1"
SCALA_VERSION="2.13"
KAFKA_ARCHIVE="kafka-${KAFKA_VERSION}-src.tgz"
KAFKA_DOWNLOAD_URL="https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/${KAFKA_ARCHIVE}"
KAFKA_INSTALL_DIR="/opt/kafka-${KAFKA_VERSION}"
KAFKA_DIR="/opt/kafka"
ZOOKEEPER_SERVICE_FILE="/etc/systemd/system/zookeeper.service"
KAFKA_SERVICE_FILE="/etc/systemd/system/kafka.service"

# Step 1: Download Kafka to ~/hadoop_cluster directory
echo "Downloading Kafka..."
mkdir -p ~/hadoop_cluster
cd ~/hadoop_cluster
wget ${KAFKA_DOWNLOAD_URL} -O ${KAFKA_ARCHIVE} || { echo "Download failed. Exiting."; exit 1; }

# Step 2: Extract Kafka archive
echo "Extracting Kafka..."
tar xzf ${KAFKA_ARCHIVE}

# Step 3: Move Kafka to /opt and create a symlink
echo "Moving Kafka to /opt and creating symlink..."
sudo mv -f kafka-${KAFKA_VERSION}-src ${KAFKA_INSTALL_DIR}
sudo ln -s ${KAFKA_INSTALL_DIR} ${KAFKA_DIR}

# Step 4: Configure environment variables
echo "Setting up environment variables..."
# cat <<EOF >> ~/.bashrc

# Kafka
export KAFKA_HOME=${KAFKA_DIR}
export PATH=\$PATH:\${KAFKA_HOME}/bin
EOF
source ~/.bashrc

# Step 5: Validate if all necessary jar files are present, build if needed
echo "Checking for necessary Kafka jar files..."
cd ${KAFKA_DIR}
if [ ! -f libs/kafka-clients*.jar ]; then
    echo "Missing Kafka jar files. Building Kafka jars..."
    ./gradlew jar -PscalaVersion=${SCALA_VERSION}
fi

echo "Finised installing Kafka .. you can start running it...."
