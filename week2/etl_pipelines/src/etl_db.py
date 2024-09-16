import psycopg2
from extract.extract_db import extract_db_data
from transform.transform_db import transform_db_data
from load.load_db import load_db_data

# DB connection
db_conn = psycopg2.connect(
    host="localhost",
    port=5432,
    database="postgres",
    user="postgres",
    password="postgres"
)
# Creating up the cursor
db_cursor = db_conn.cursor()

# Extract
df_extracted = extract_db_data(db_cursor)
print(f"Extracted data: \n{df_extracted}")

# Transform
df_transformed = transform_db_data(df_extracted, db_cursor)
db_conn.commit()
print(f"Transformed data: \n{df_transformed}")

# Load:
load_db_data(df_transformed, db_conn)

print("ETL_db is DONE!!")
