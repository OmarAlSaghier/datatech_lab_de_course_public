### Hands-On Exercise: **Data Visualization using MS Power BI and Apache Superset**

In this exercise, you will learn how to visualize retail data using two popular tools for data visualization:
1. **MS Power BI**: A powerful business analytics tool.
2. **Apache Superset**: An open-source data exploration and visualization platform.

We'll explore how to connect these tools to a Hadoop cluster, retrieve data, and create visual reports.

---

## Section 1: **Data Visualization with MS Power BI**

### **Step 1: Setting Up the Environment**

1. **Install MS Power BI**:
   - Download Power BI from the [official site](https://powerbi.microsoft.com/en-us/downloads/).
   - Follow the installation steps for your operating system.

2. **Configure Hadoop Connectivity**:
   - Power BI does not directly connect to HDFS, so we will need to extract the retail data from HDFS into a CSV or database format (e.g., Hive or MySQL).
   - Alternatively, you can set up a JDBC or ODBC connector to Hive for direct query.

### **Step 2: Load Retail Data into Power BI**

1. **Extract data from Hadoop**:
   - Extract your retail data from HDFS and store it in Hive using the following command:
   
     ```sql
     INSERT OVERWRITE LOCAL DIRECTORY '/tmp/retail_data'
     ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
     SELECT * FROM retail_table;
     ```

2. **Import Data into Power BI**:
   - Open Power BI and click on **Home → Get Data → Text/CSV** to load the retail data CSV.
   - Alternatively, if using Hive, click **Home → Get Data → Other → ODBC** and connect to your Hive instance via ODBC.

3. **Transform Data**:
   - Once the data is loaded, use **Power Query Editor** to clean and transform the data as needed (e.g., removing null values, renaming columns, etc.).

### **Step 3: Creating Visualizations in Power BI**

1. **Create Basic Charts**:
   - Go to the **Report View** in Power BI.
   - Use the fields from the retail dataset (e.g., sales, products, regions) to create visualizations.
     - Example 1: **Bar Chart** to show sales per product category.
     - Example 2: **Line Chart** to show sales trends over time.

2. **Create Interactive Dashboards**:
   - Add multiple visuals on one page and use **slicers** for interactivity (e.g., filtering by date or region).
   - Link charts to show how interactions affect one another (e.g., selecting a region in a map filters the sales data in other visuals).

3. **Data Modeling and Relationships**:
   - If your dataset is split across multiple files (e.g., sales, products, customers), you can build relationships in Power BI’s **Model View**.
   - Define relationships between tables (e.g., link customer data to sales via customer ID).

4. **Publish Your Report**:
   - Once your report is complete, click on **File → Publish → Publish to Power BI Service** to share it online or embed it into dashboards for reporting.

---
