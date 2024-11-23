#!/bin/bash

REPO_DIR=$(pwd)
if [[ "${REPO_DIR##*/}" != "pipelines_automation" ]]; then
    echo "Please navigate to the 'pipelines_automation' directory before running this script."
    exit 1
fi
cd airflow_running_env
ls -l

AIRFLOW_HOME=$(pwd)
export AIRFLOW_HOME
nohup airflow webserver -p 8080 > webserver.log 2>&1 &
nohup airflow scheduler > scheduler.log 2>&1 &
echo "Airflow started. Webserver and Scheduler are running in the background."
