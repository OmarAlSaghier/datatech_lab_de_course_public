#!/bin/bash

# Variables
FLINK_VERSION="1.16.0"
FLINK_ARCHIVE="flink-${FLINK_VERSION}-bin-scala_2.12.tgz"
FLINK_DOWNLOAD_URL="https://archive.apache.org/dist/flink/flink-${FLINK_VERSION}/${FLINK_ARCHIVE}"
FLINK_INSTALL_DIR="/opt/flink-${FLINK_VERSION}"
FLINK_SYMLINK="/opt/flink"
FLINK_SERVICE_FILE="/etc/systemd/system/flink.service"

# Step 1: Download Apache Flink
echo "Downloading Apache Flink..."
mkdir -p ~/hadoop_cluster
cd ~/hadoop_cluster
# wget ${FLINK_DOWNLOAD_URL} -O ${FLINK_ARCHIVE} || { echo "Download failed. Exiting."; exit 1; }

# Step 2: Extract Flink archive
echo "Extracting Apache Flink..."
tar xzf ${FLINK_ARCHIVE}

# Step 3: Move Flink to /opt and create a symlink
echo "Moving Flink to /opt and creating symlink..."
sudo mv -f flink-${FLINK_VERSION} ${FLINK_INSTALL_DIR}
sudo ln -s ${FLINK_INSTALL_DIR} ${FLINK_SYMLINK}

# Step 4: Configure environment variables
echo "Configuring environment variables..."
echo -e "\n# Flink Environment" >> ~/.bashrc
echo "export FLINK_HOME=${FLINK_SYMLINK}" >> ~/.bashrc
echo "export PATH=\$PATH:\${FLINK_HOME}/bin" >> ~/.bashrc
source ~/.bashrc

# Step 5: add python interpreter
echo "python.executable: /usr/bin/python3" >> /opt/flink/conf/flink-conf.yaml

# Step 6: download required Jars for kafka:
wget https://repo1.maven.org/maven2/org/apache/flink/flink-connector-kafka/1.16.0/flink-connector-kafka-1.16.0.jar -P /opt/flink/lib/
wget https://repo1.maven.org/maven2/org/apache/kafka/kafka-clients/3.3.1/kafka-clients-3.3.1.jar -P /opt/flink/lib/


# # Step 5: Create Flink systemd service
# echo "Creating Flink systemd service..."
# sudo tee ${FLINK_SERVICE_FILE} > /dev/null <<EOF
# [Unit]
# Description=Apache Flink Cluster
# After=network.target

# [Service]
# Type=forking
# ExecStart=${FLINK_SYMLINK}/bin/start-cluster.sh
# ExecStop=${FLINK_SYMLINK}/bin/stop-cluster.sh
# Restart=on-abnormal

# [Install]
# WantedBy=multi-user.target
# EOF

# # Step 6: Reload systemd and enable Flink service
# echo "Reloading systemd daemon and enabling Flink service..."
# sudo systemctl daemon-reload
# sudo systemctl enable flink

# # Step 7: Start Flink service
# echo "Starting Flink service..."
# sudo systemctl start flink

# # Step 8: Validate Flink installation
# echo "Validating Flink installation..."
# if systemctl is-active --quiet flink; then
#     echo "Flink cluster is up and running!"
#     echo "Access the Flink Web UI at http://localhost:8081"
# else
#     echo "Flink cluster failed to start. Check logs for details."
# fi


echo "Apache Flink installation and setup complete!"
