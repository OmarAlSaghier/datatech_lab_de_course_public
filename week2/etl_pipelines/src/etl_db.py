from extract.extract_db import extract_db_data
from transform.transform_db import transform_db_data
from load.load_db import load_db_data

# Extract
df_extracted, db_conn = extract_db_data()
print(df_extracted)

# Transform
df_transformed, db_conn = transform_db_data(df_extracted, db_conn)
print(df_transformed)

# Load:
load_db_data(df_transformed, db_conn)

print("ETL_db is DONE!!")
