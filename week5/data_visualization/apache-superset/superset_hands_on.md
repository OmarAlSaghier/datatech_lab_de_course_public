

## Section 2: **Data Visualization with Apache Superset**

### **Step 1: Setting Up Apache Superset**

1. **Install Apache Superset**:
   - Follow the [official installation guide](https://superset.apache.org/docs/installation/docker-compose/) to set up Apache Superset on your system or cluster.

2. **Run Superset using docker-compose**:
   - Get the required files from Git repo: `git clone --depth=1  https://github.com/apache/superset.git`
   - Change directory: `cd superset`
   - Run using docker compose: `docker compose --project-name apache_superset_learning -f docker-compose-non-dev.yml up -d` 
   - Access Superset at `http://localhost:8088`.
   - Login with the default credentials: `admin/admin`.
   

3. **Connecting to the previously created and loaded PostgresDB**:
   - The postgresDB we previously created will be the source of data for Superset.

### **Step 2: Connecting to Hive from Superset**

1. **Import Data from Hive**:
   - In Superset, go to **Sources → Tables** and click on **+ Table**.
   - Select the **Hive** database connection and choose the `retail_table` from the dropdown.
   - Click **Save**.

2. **Explore Data**:
   - In **Superset Explore**, start by selecting the `retail_table`.
   - This will allow you to explore the retail data directly in the UI.

### **Step 3: Creating Visualizations in Superset**

1. **Basic Visualizations**:
   - Create a **Bar Chart** to show sales per product category.
     - Select **Bar Chart** from the visualization types, then drag and drop the `category` dimension and `sales_amount` metric.
   - Create a **Time-Series Line Chart** to visualize sales trends over time.
     - Choose the `sales_date` column for the X-axis and `sales_amount` as the metric.

2. **Dashboard Creation**:
   - Create a new dashboard by navigating to **Dashboards** and clicking **+ Dashboard**.
   - Add the charts you’ve created to the dashboard.
   - You can add **filters** like date ranges or categories to make the dashboard interactive.

3. **Advanced Visualizations**:
   - Use **Heatmaps** to show sales distribution across regions.
   - Create a **Geospatial Map** using the latitude and longitude columns (if available) or by aggregating sales at the country/region level.

4. **Publishing and Sharing**:
   - Once your dashboard is ready, you can save it and share it with team members.
   - Superset also allows embedding of dashboards into other applications or websites.

### **Step 4: Integrating with HDFS and Hive**

1. **Querying Data from HDFS via Hive**:
   - Superset allows querying data directly from Hive tables stored in HDFS.
   - You can use SQL Lab to write custom queries and visualize the result:
   
     ```sql
     SELECT category, SUM(sales_amount) AS total_sales
     FROM retail_table
     GROUP BY category
     ORDER BY total_sales DESC;
     ```

2. **Data Caching and Performance**:
   - Superset supports data caching for faster querying and rendering of visualizations. You can configure caching to reduce query execution time.

---

### **Section 3: Combining Power BI and Superset in a Real-World Use Case**

- In a real-world scenario, you might want to use both tools in combination:
  - **Power BI** for deep, detailed business analysis and interactivity.
  - **Superset** for open-source data exploration and lightweight visualizations.

---

### **Exercise Conclusion**

In this hands-on exercise, you’ve learned how to:
1. Use **MS Power BI** to load retail data, transform it, and create interactive dashboards.
2. Use **Apache Superset** to connect to Hive, explore retail data, and build a visualization dashboard.
3. Work with **HDFS** and **Hive** to query big data using these visualization tools.

Both tools provide powerful capabilities to visualize and analyze big data, and you can choose the tool that best fits your workflow based on requirements such as ease of use, scalability, and cost.