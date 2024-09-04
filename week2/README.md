# Week 2: Data Pipelines and Big Data Processing

## Overview
This week's workshop will focus on data pipelines and big data processing. We will start by understanding the concepts of Extract, Transform, Load (ETL) processes and designing efficient data pipelines. We will also cover data quality and data cleansing techniques. In the hands-on session, you will build a simple ETL pipeline using Python.

In the second part of the workshop, we will introduce you to big data and distributed computing. You will learn about the principles of distributed systems and the Hadoop ecosystem, including HDFS, MapReduce, and YARN. We will also provide an overview of Apache Spark and guide you through setting up a Hadoop cluster and running basic operations.

## Learning Objectives
By the end of this workshop, you will be able to:
- Understand Extract, Transform, Load (ETL) processes and their importance in data engineering.
- Design and implement efficient data pipelines for processing large datasets.
- Apply data quality and data cleansing techniques to ensure data integrity.
- Work with distributed computing frameworks like Hadoop and Spark.
- Set up a Hadoop cluster and run basic operations using HDFS and MapReduce.

## Activities

Run PostgreSQL DB with docker compose
```
docker compose \
	-f source_data/postgres_db/docker_compose_etl.yml \
	--project-name datatech_de_course_week2 \
	up -d
```