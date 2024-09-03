# Week 1: Hands-On Introduction to Data Engineering

## Overview
This hands-on workshop consists of two parts, Python programming and SQL. The Python programming part will introduce you to the basics of Python programming, including data types, variables, operators, and control structures. The SQL part will cover the basics of SQL, including data definition, data manipulation, and data querying.

## Learning Objectives
By the end of this workshop, you will be able to:
- Write Python programs to perform basic data processing tasks.
- Write SQL queries to create, update, and query databases.

## Activities
- **Part 1: Python Programming**
  - Open the `python/python_for_data_engineers.ipynb` notebook in VSCode.
  - The file has many execises and examples to help you learn Python programming. including:
    - Introduction to Python
    - Data types and variables
    - Operators and expressions
    - Control structures (if, for, while)
    - Functions and modules
    - File I/O

- **Part 2: SQL Basics**
  - Open the `sql/sql_for_data_engineers.ipynb` file in VSCode.
  - The file has many execises and examples to help you learn SQL basics, including:
    - Introduction to SQL
    - Data definition (CREATE, ALTER, DROP)
    - Data manipulation (INSERT, UPDATE, DELETE)
    - Data querying (SELECT, WHERE, GROUP BY, JOIN)

- **Part 3: NoSQL Databases**
  - Read the `nosql/nosql_databases.md` file in VSCode.
  - The file provides an overview of NoSQL databases and how they differ from traditional SQL databases.

Running the docker compose file:
```
docker compose \
  -f course_hands_on/week1/sql/docker_compose.yml \
  --project-name datatech_de_course \
  up -d
```