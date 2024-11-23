from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime

# Define DAG arguments
default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 11, 22),
    'retries': 1,
}

# Instantiate a DAG
dag = DAG(
    'simple_dag',
    default_args=default_args,
    schedule_interval='@daily'
)

# Define tasks
t1 = BashOperator(
    task_id='print_date',
    bash_command='date',
    dag=dag
)

t2 = BashOperator(
    task_id='sleep',
    bash_command='sleep 5',
    dag=dag
)

t3 = BashOperator(
    task_id='current_working_dir',
    bash_command='pwd',
    dag=dag
)

# Define task dependencies
t1 >> t2 >> t3
