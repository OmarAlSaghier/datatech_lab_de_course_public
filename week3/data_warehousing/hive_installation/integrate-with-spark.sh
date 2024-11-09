#!/bin/bash

# Set Hive and Spark installation directories
HIVE_CONF_DIR="/opt/hive/conf"
SPARK_CONF_DIR="/opt/spark/conf"
SPARK_JARS_DIR="/opt/spark/jars"
POSTGRES_JDBC_URL="https://jdbc.postgresql.org/download/postgresql-42.2.24.jar"

# Step 1: Create a soft link for hive-site.xml in Spark's conf folder
echo "Creating soft link for hive-site.xml in Spark's conf directory..."
sudo ln -sf ${HIVE_CONF_DIR}/hive-site.xml ${SPARK_CONF_DIR}/

# Step 2: Download and place the Postgres JDBC driver in Spark's jars directory
echo "Downloading PostgreSQL JDBC driver..."
sudo wget -q ${POSTGRES_JDBC_URL} -O ${SPARK_JARS_DIR}/postgresql-42.2.24.jar

# Step 3: Update log4j2 properties for Spark to reduce log-level to ERROR
echo "Updating Spark log level to 'error' only..."
sudo cp ${SPARK_CONF_DIR}/log4j2.properties.template ${SPARK_CONF_DIR}/log4j2.properties
sudo sed -i 's/rootLogger.level = info/rootLogger.level = error/' ${SPARK_CONF_DIR}/log4j2.properties

# Final message
echo "Spark integration with Hive is complete. You can now start the PySpark shell and run:"
echo "spark.sql('SHOW databases').show()"
