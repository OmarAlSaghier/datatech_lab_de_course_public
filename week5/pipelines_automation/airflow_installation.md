# Run Airflow with Python Virtual Environments
Ref: https://www.youtube.com/watch?v=z7xyNOF8tak


### Change directory into `Airflow_virtual_venv` directory

1. Create virtual environment
```
$ python3 -m venv airflow_venv
```

2. start the venv
```
$ source airflow_venv/bin/activate
```

3. From the official github repo:
https://github.com/apache/airflow

Install airflow using the below command
make sure to change the constraints-3.xx to your python version
```
$ pip install 'apache-airflow==2.5.0' \
 --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.5.0/constraints-3.10.txt"
 ```

4. After installation, export AIRFLOW_HOME to the desired directory
```
$ export AIRFLOW_HOME=/home/<your-full-path>/zaka_de_public/Data_Warehousing_Pipeline_Automation/Airflow_virtual_env
```

5. Initialize the database with:
```
$ airflow db init
```

6. In the newly created `airflow.cfg` file, Change the `sql_alchemy_conn` parameter by only replace the dot in `sqlite:///./airflow.db` with the full path like
```
sql_alchemy_conn = sqlite:////home/<you_path>/zaka_de_public/Data_Warehousing_Pipeline_Automation/Airflow_virtual_env/airflow.db
```


7. Re-initialize the database again using `airflow db init` and check db connection using:
```
$ airflow db check
```

8. Start Airflow webserver:
```
$ airflow webserver -p 8080
```

9. Open another terminal window, change your directory into `Airflow_virtual_venv`, source into your virtual environment, export airflow home by `export AIRFLOW_HOME=<your-path>`, and Create a user for logging in
```
$ airflow users create \
    --username airflow \
    --firstname fname \
    --lastname lname \
    --email admin@domain.com \
    --role Admin
```

10. Start airflow scheduler
```
$ airflow scheduler
```

****

### To Rerun Airflow Again After the First Setup
* Terminal_1:
```
$ export AIRFLOW_HOME=/home/<your-full-path>/zaka_de_public/Data_Warehousing_Pipeline_Automation/Airflow_virtual_env
$ airflow webserver -p 8080
```
* Terminal_2:
```
$ export AIRFLOW_HOME=/home/<your-full-path>/zaka_de_public/Data_Warehousing_Pipeline_Automation/Airflow_virtual_env
$ airflow scheduler
```
