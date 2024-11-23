from pyspark.sql import SparkSession
from pyspark.sql.functions import col, explode

# Initialize Spark Session
spark = SparkSession.builder \
    .appName("WeatherDataTransformation") \
    .enableHiveSupport() \
    .getOrCreate()

# Load raw JSON data
df = spark.read.json("file:///tmp/weather_data.json")

# Perform transformations (e.g., filter rows, select columns)
df_filtered = df.select(
    explode(col("hourly.temperature_2m")).alias("temperature"),
    col("latitude"),
    col("longitude")
)

# Save the transformed data to HDFS in Parquet format
df_filtered.write.mode("append").parquet("/user/datatech-labs/processed_weather_data")

# Stop Spark session
spark.stop()
