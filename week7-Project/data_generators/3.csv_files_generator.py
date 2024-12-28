import csv
from datetime import datetime, timedelta
import random

columns = ["campaign_id", "channel", "clicks", "conversions", "spend", "date"]
channels = ["Google Ads", "Facebook", "Email", "Twitter"]

for file_num in range(1, 11):
    with open(f"marketing_data_{file_num}.csv", mode="w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(columns)
        for row_num in range(100):
            writer.writerow([
                f"CMP-{row_num + file_num * 100}",
                random.choice(channels),
                random.randint(50, 1000),
                random.randint(1, 100),
                round(random.uniform(100.0, 1000.0), 2),
                (datetime(2023, 1, 1) + timedelta(days=random.randint(0, 365))).strftime("%Y-%m-%d")
            ])
