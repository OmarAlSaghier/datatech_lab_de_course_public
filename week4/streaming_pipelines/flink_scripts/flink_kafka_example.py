#!/usr/bin/env python3

from pyflink.datastream import StreamExecutionEnvironment
from pyflink.table import StreamTableEnvironment

env = StreamExecutionEnvironment.get_execution_environment()
table_env = StreamTableEnvironment.create(env)

# Create Kafka Source Table
table_env.execute_sql("""
    CREATE TABLE kafka_source (
        number INT
    ) WITH (
        'connector' = 'kafka',
        'topic' = 'flink-topic',
        'properties.bootstrap.servers' = 'localhost:9092',
        'properties.group.id' = 'flink-consumer-group',
        'scan.startup.mode' = 'earliest-offset',
        'format' = 'json'
    )
""")

result = table_env.sql_query("""
    SELECT number, COUNT(*) FROM kafka_source GROUP BY number
""")

# Print the results
result.execute().print()
