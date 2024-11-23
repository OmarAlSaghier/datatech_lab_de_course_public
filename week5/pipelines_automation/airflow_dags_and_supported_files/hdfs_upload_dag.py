import requests
from datetime import datetime
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator

# Define default arguments
default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 11, 22),
    'retries': 1,
}

# Define the DAG
dag = DAG(
    'hdfs_data_workflow_dag',
    default_args=default_args,
    schedule_interval='@daily'
)

# Define Python function to fetch data from API
def fetch_data():
    response = requests.get("https://dummyjson.com/users")
    with open('/tmp/data.json', 'w') as f:
        f.write(response.text)

# Define tasks
fetch_task = PythonOperator(
    task_id='fetch_data_from_api',
    python_callable=fetch_data,
    dag=dag
)

process_task = BashOperator(
    task_id='process_data',
    bash_command='cat /tmp/data.json | jq . > /tmp/processed_data.json',
    dag=dag
)

create_dir_task = BashOperator(
    task_id='create_hdfs_dir',
    bash_command='hdfs dfs -mkdir -p /user/datatech-labs/airflow_processed_data',
    dag=dag
)

load_task = BashOperator(
    task_id='load_to_hdfs',
    bash_command='hdfs dfs -put /tmp/processed_data.json /user/datatech-labs/airflow_processed_data',
    dag=dag
)

# Set task dependencies
fetch_task >> process_task >> create_dir_task >> load_task
