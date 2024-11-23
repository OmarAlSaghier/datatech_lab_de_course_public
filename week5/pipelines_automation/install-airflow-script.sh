#!/bin/bash

# Step 1: Change directory into airflow_running_env
REPO_DIR=$(pwd)
if [[ "${REPO_DIR##*/}" != "pipelines_automation" ]]; then
    echo "Please navigate to the 'pipelines_automation' directory before running this script."
    exit 1
fi

mkdir -p ./airflow_running_env
cd ./airflow_running_env || exit

# Step 2: Create and activate a virtual environment
# python3 -m venv airflow_venv
# source airflow_venv/bin/activate

# Step 3: Install Apache Airflow with version constraints
PYTHON_VERSION=$(python --version | cut -d' ' -f2 | cut -d. -f1,2)  # Get Python major.minor version
pip install 'apache-airflow==2.5.0' \
  --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.5.0/constraints-${PYTHON_VERSION}.txt"

# Step 4: Set AIRFLOW_HOME environment variable
AIRFLOW_HOME=$(pwd)
export AIRFLOW_HOME
echo "AIRFLOW_HOME set to $AIRFLOW_HOME"

# Step 5: Initialize Airflow database
airflow db init

# Step 6: Update sql_alchemy_conn in airflow.cfg
AIRFLOW_CFG_FILE="${AIRFLOW_HOME}/airflow.cfg"
DB_PATH="${AIRFLOW_HOME}/airflow.db"
sed -i "s|sqlite:///./airflow.db|sqlite:///${DB_PATH}|g" "$AIRFLOW_CFG_FILE"

# Step 7: Reinitialize the database and check the connection
airflow db init
airflow db check

# Step 8: Start Airflow webserver
echo "Starting Airflow webserver on port 8080..."
nohup airflow webserver -p 8080 > webserver.log 2>&1 &

# Step 9: Create an Airflow admin user
echo "Creating Airflow admin user with 'airflow' username and 'admin' password..."
airflow users create \
    --username airflow \
    --firstname admin \
    --lastname admin \
    --email admin@domain.com \
    --role Admin \
    --password admin

# Step 10: Start Airflow scheduler
echo "Starting Airflow scheduler..."
nohup airflow scheduler > scheduler.log 2>&1 &

echo "Airflow setup complete. Access the web UI at http://localhost:8080"
echo "Login with 'airflow' username and 'admin' password"
