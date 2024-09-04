import os
from extract.extract_files import extract_batch_files
from transform.transform_files import transform_data
from load.load_files import load_data

# main variables
cwd = os.getcwd()
source_dir = f"{cwd}/source_data/data_files/dealership_data"
file_to_save = "result_batch.csv"
dist_dir = f"{cwd}/source_data/data_files/data_results/{file_to_save}"

# Extract
df = extract_batch_files(source_dir)
print(f"dataFrame shape: {df.shape}")
print(df)

# Transform
df = transform_data(df)
print("Dataframe after transformation:")
print(df)

# Load:
load_data(df, dist_dir)

print("ETL_batch is DONE!!")
