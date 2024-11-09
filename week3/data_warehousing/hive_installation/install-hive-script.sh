#!/bin/bash

# Define global variables
HIVE_VERSION="3.1.2"

# Running directory
REPO_DIR=$(pwd)
if [[ "${REPO_DIR##*/}" != "datatech_lab_de_course_public" ]]; then
    echo "Please navigate to the 'datatech_lab_de_course_public' directory before running this script."
    exit 1
fi

# Step 1: Check if the user is in the Docker group
if ! groups $USER | grep -q '\bdocker\b'; then
    echo "Adding $USER to the Docker group..."
    sudo usermod -aG docker $USER
    echo "Please log out the session, and log back in to activate Docker group membership."
    exit 1
fi

echo "Starting Apache Hive Installation..."

# Step 2: Create a directory for downloading Hive and navigate to it
mkdir -p ~/hadoop_cluster && cd ~/hadoop_cluster

# Step 3: Download Apache Hive
echo "Downloading Apache Hive version $HIVE_VERSION..."
wget https://apache.root.lu/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz

# Step 4: Extract the downloaded file
echo "Extracting Apache Hive..."
tar xzf "apache-hive-$HIVE_VERSION-bin.tar.gz"

# Step 5: Move Hive to /opt and create a symlink
echo "Moving Hive to /opt and creating symbolic link..."
sudo mv -f "apache-hive-$HIVE_VERSION-bin" /opt/
sudo ln -s "/opt/apache-hive-$HIVE_VERSION-bin" /opt/hive

# Step 6: Add Hive environment variables to .bashrc
echo "Adding Hive environment variables..."
cat <<EOL >> ~/.bashrc

# Hive
export HIVE_HOME=/opt/hive
export PATH=$PATH:${HIVE_HOME}/bin
EOL

source ~/.bashrc

# Step 7: Copy hive-site.xml to Hive conf directory
echo "Copying hive-site.xml configuration file..."
sudo cp $REPO_DIR/week3/data_warehousing/hive_installation/hive-site.xml /opt/hive/conf/

# Step 8: Create necessary HDFS directories for Hive and set permissions
echo "Creating Hive directories in HDFS..."
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /user/tmp
hdfs dfs -chmod g+w /user/tmp
hdfs dfs -chmod g+w /user/hive/warehouse

# Step 9: Update Guava library in Hive lib directory with the version from Hadoop
echo "Updating Guava library in Hive..."
sudo rm -f /opt/hive/lib/guava-*.jar
sudo cp /opt/hadoop/share/hadoop/hdfs/lib/guava-27.0-jre.jar /opt/hive/lib/

# Step 9-b: Download PostgreSQL JDBC Driver for Hive Metastore
echo "Downloading PostgreSQL JDBC driver for Hive Metastore..."
wget https://jdbc.postgresql.org/download/postgresql-42.2.24.jar -P /opt/hive/lib/

# Step 10: Set up PostgreSQL for Hive Metastore using Docker
echo "Setting up PostgreSQL container for Hive Metastore..."
docker pull postgres
docker create \
    --name hive_meta_store_db \
    -p 5432:5432 \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres \
    postgres

docker start hive_meta_store_db

# Wait for the PostgreSQL container to initialize
sleep 5

# Step 11: Create the Hive metastore database and user in PostgreSQL
echo "Creating Hive Metastore database and user..."
docker exec -it hive_meta_store_db psql -U postgres -c "CREATE DATABASE metastore;"
docker exec -it hive_meta_store_db psql -U postgres -c "CREATE USER hive WITH ENCRYPTED PASSWORD 'hive';"
docker exec -it hive_meta_store_db psql -U postgres -c "GRANT ALL ON DATABASE metastore TO hive;"
docker exec -it hive_meta_store_db psql -U postgres -c "ALTER USER hive WITH SUPERUSER;"

# Step 12: Modify pg_hba.conf to allow connections from all IPs
echo "Modifying pg_hba.conf to allow all IP connections..."
docker exec -it hive_meta_store_db sed -i 's/^host\s\+all\s\+all\s\+127.0.0.1\/32\s\+trust/host    all             all             0.0.0.0\/0               trust/' /var/lib/postgresql/data/pg_hba.conf

# Reload PostgreSQL configuration to apply changes
docker exec -it hive_meta_store_db psql -U postgres -c "SELECT pg_reload_conf();"

# Step 13: Initialize the Hive metastore schema using schematool
echo "Initializing Hive metastore schema..."
schematool -initSchema -dbType postgres

echo "Apache Hive installation and setup complete!"
