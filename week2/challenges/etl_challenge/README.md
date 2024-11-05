### Week 2 Challenge: **Design and Implement an ETL Pipeline Using Python**

#### **Business Requirements**

Your challenge is to build an ETL pipeline for a fictional online retail company, **ShopEZ**, that needs to analyze customer and transaction data stored in different sources. The data is partially located in a **PostgreSQL database** and partially in **CSV files**. The goal is to extract, transform, and load this data into a single **PostgreSQL table** that can be used for further analysis, reporting, and insights.

---

### **Project Overview**

The **ShopEZ** company tracks various customer and sales data points but currently stores them in disparate sources. As a data engineer, you will design and implement an ETL pipeline using Python that meets the following requirements:

1. **Extract**: Retrieve data from a PostgreSQL database and CSV files.
2. **Transform**: Perform data cleaning, validation, and transformations to ensure consistency across sources.
3. **Load**: Consolidate the cleaned and transformed data into a single table in PostgreSQL for analysis.

This exercise will test your ability to analyze requirements, handle different data sources, and create an effective ETL pipeline that integrates data into one unified table.

---

### **Datasets**

#### 1. **Customer Data (in PostgreSQL)**
   - Database Table: `customers`
   - Columns:
     - `customer_id` (INTEGER, Primary Key): Unique identifier for each customer
     - `name` (VARCHAR): Customer’s name
     - `email` (VARCHAR): Customer’s email address
     - `join_date` (DATE): Date when the customer joined
     - `location` (VARCHAR): Customer’s location (city/state)

#### 2. **Transactions Data (in CSV)**
   - File Name: `transactions.csv`
   - Columns:
     - `transaction_id` (INTEGER, Primary Key): Unique identifier for each transaction
     - `customer_id` (INTEGER): Customer ID associated with the transaction
     - `transaction_date` (DATE): Date of the transaction
     - `amount` (FLOAT): Total amount of the transaction
     - `product` (VARCHAR): Product name

#### 3. **Products Data (in CSV)**
   - File Name: `products.csv`
   - Columns:
     - `product_id` (INTEGER, Primary Key): Unique identifier for each product
     - `product_name` (VARCHAR): Name of the product
     - `category` (VARCHAR): Product category (e.g., "Electronics", "Clothing")
     - `price` (FLOAT): Product price

---

### **Challenge Goal**

Create a unified **PostgreSQL table** called `customer_transactions` with the following schema:

- `transaction_id` (INTEGER): Unique identifier for each transaction
- `customer_id` (INTEGER): Customer ID associated with the transaction
- `customer_name` (VARCHAR): Name of the customer
- `customer_email` (VARCHAR): Email of the customer
- `transaction_date` (DATE): Date of the transaction
- `amount` (FLOAT): Total amount of the transaction
- `product` (VARCHAR): Name of the product
- `product_category` (VARCHAR): Category of the product
- `customer_location` (VARCHAR): Location of the customer

This table should combine and match the customer, transaction, and product details.

---

### **Steps and Requirements**

**Pre-requisites**:
- Insert the `customers` data into the PostgreSQL database manually using the provided SQL statements in the same folder.
- Save the `transactions.csv` and `products.csv` data into respective CSV files and place them in a directory accessible by their Python script.
- Follow the ETL pipeline steps in the challenge to integrate data from PostgreSQL and CSV files into the `customer_transactions` table in PostgreSQL.

**Steps**:
1. **Analyze the Data Sources**: Understand the schemas of the `customers` table (PostgreSQL), `transactions.csv`, and `products.csv`. Identify the relationships:
   - Each `transaction` is associated with a `customer` via the `customer_id` key.
   - Each `transaction` is associated with a `product` via the `product` field in `transactions.csv` and the `product_name` in `products.csv`.

2. **Data Extraction**:
   - Extract customer data from the PostgreSQL `customers` table.
   - Load transaction data from `transactions.csv`.
   - Load product data from `products.csv`.

3. **Data Transformation**:
   - Validate and clean data for consistency, e.g., ensure dates are in a consistent format and remove any duplicate or null entries.
   - Enrich the `transactions` data with customer information (name, email, and location) from the `customers` table and product details (category) from `products.csv`.
   - Handle any potential data discrepancies (e.g., missing customer IDs or mismatched products) by deciding on an approach (e.g., filtering out invalid records or using default values).

4. **Data Loading**:
   - Create the `customer_transactions` table in PostgreSQL.
   - Load the cleaned and combined data into this table.

5. **Testing and Validation**:
   - Ensure that all data has been transferred and combined correctly by running simple validation queries (e.g., count checks, inspecting sample rows).
   - Confirm the relationships by checking that each `transaction` has the correct customer and product details.

---

### **Expected Outcome**

At the end of this challenge, you should have a fully functioning ETL pipeline written in Python that:
- Extracts data from multiple sources (PostgreSQL and CSVs).
- Transforms and combines data to match the `customer_transactions` schema.
- Loads the integrated data into a PostgreSQL table, ready for further analysis.

### **Submission**

Submit your Python script(s) for the ETL pipeline along with a README file that explains:
- The design and reasoning behind your pipeline steps.
- Any assumptions you made or challenges you encountered.
- Example SQL queries that validate your results (e.g., checking for correct joins).

---

### **Hints**

- Use libraries such as `pandas` for data loading and transformation, and `psycopg2` or `SQLAlchemy` for PostgreSQL interaction.
- Think carefully about handling missing or mismatched data—decide whether to exclude, replace, or correct these records.
- Document your code to make it clear which steps are extracting, transforming, and loading the data.