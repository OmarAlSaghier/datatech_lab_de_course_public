from pyspark.sql import SparkSession

# Initialize Spark Session
spark = SparkSession. \
    builder. \
    appName("Retail Data Analysis"). \
    getOrCreate()

# Load retail sales data from CSV
retail_df = spark.read.csv(
    "hdfs:///user/datatech-labs/retail_data/retail_data.csv",
    header=True,
    inferSchema=True
)

# Perform basic transformation
df_filtered = retail_df.filter(retail_df['total_amount'] > 100)

# Show results
df_filtered.show()