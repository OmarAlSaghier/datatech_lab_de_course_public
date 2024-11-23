import requests
import json
from airflow.models import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.operators.bash_operator import BashOperator
from datetime import datetime

# fetches weather data from an external API and stores it as a JSON file in a specific directory.
def extract_data():
    url = "https://api.open-meteo.com/v1/forecast?latitude=35&longitude=139&hourly=temperature_2m"
    response = requests.get(url)
    data = response.json()
    with open('/tmp/weather_data.json', 'w') as f:
        json.dump(data, f)

# Define DAG default arguments
default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 11, 23),
    'retries': 1,
}

# Instantiate the DAG
dag = DAG(
    'open_weather_etl_pipeline',
    default_args=default_args,
    schedule_interval=None #'@daily'
)

# Create the extraction task. PythonOperator calls this function as part of an Airflow DAG
extract_task = PythonOperator(
    task_id='extract_weather_data',
    python_callable=extract_data,
    dag=dag
)

spark_file_path = '/home/oalsaghier/Documents/datatech_labs/datatech_lab_de_course_public/week5/pipelines_automation/transform_weather_data.py'
transform_task = BashOperator(
    task_id='transform_weather_data',
    bash_command=f'spark-submit --master yarn --deploy-mode client {spark_file_path}',
    dag=dag
)


# task orchestration:
extract_task >> transform_task
