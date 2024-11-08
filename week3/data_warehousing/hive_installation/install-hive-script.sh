#!/bin/bash

# Define global variables
HIVE_VERSION="4.0.1"

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
wget "https://dlcdn.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz" || wget "https://apache.osuosl.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz"

# Step 4: Extract the downloaded file
echo "Extracting Apache Hive..."
tar xzf "apache-hive-$HIVE_VERSION-bin.tar.gz"

# Step 5: Move Hive to /opt and create a symlink
echo "Moving Hive to /opt and creating symbolic link..."
sudo mv -f "apache-hive-$HIVE_VERSION-bin" /opt/
sudo ln -s "/opt/apache-hive-$HIVE_VERSION-bin" /opt/hive

# Step 6: Add Hive environment variables to .bashrc
echo "Adding Hive environment variables..."
echo "export HIVE_HOME=/opt/hive" >> ~/.bashrc
echo "export PATH=\$PATH:\${HIVE_HOME}/bin" >> ~/.bashrc
source ~/.bashrc

# Step 7: Copy hive-site.xml to Hive conf directory
echo "Copying hive-site.xml configuration file..."
sudo cp ~/hadoop_cluster/hive-site.xml /opt/hive/conf/

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

# Step 10: Set up PostgreSQL for Hive Metastore using Docker
echo "Setting up PostgreSQL container for Hive Metastore..."
docker pull postgres
docker create \
    --name hive_meta_store_db \
    -p 5432:5432 \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres \
    -v ~/apps/postgres_hms/data:/var/lib/postgresql/data \
    postgres

docker start hive_meta_store_db

# Wait for the PostgreSQL container to initialize
sleep 5

# Step 11: Create the Hive metastore database and user in PostgreSQL
echo "Creating Hive Metastore database and user..."
docker exec -it hive_meta_store_db psql -U postgres -c "CREATE DATABASE metastore;"
docker exec -it hive_meta_store_db psql -U postgres -c "CREATE USER hive WITH ENCRYPTED PASSWORD 'hive';"
docker exec -it hive_meta_store_db psql -U postgres -c "GRANT ALL ON DATABASE metastore TO hive;"

# Step 12: Modify pg_hba.conf to allow connections from all IPs
echo "Modifying pg_hba.conf to allow all IP connections..."
echo "host    all             all             0.0.0.0/0               trust" | sudo tee -a ~/apps/postgres_hms/data/pg_hba.conf

# Reload PostgreSQL configuration to apply changes
docker exec -it hive_meta_store_db psql -U postgres -c "SELECT pg_reload_conf();"

# Step 13: Initialize the Hive metastore schema using schematool
echo "Initializing Hive metastore schema..."
schematool -initSchema -dbType postgres

echo "Apache Hive installation and setup complete!"
