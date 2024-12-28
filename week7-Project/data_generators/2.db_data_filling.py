import psycopg2
import random
from datetime import datetime, timedelta

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname="transactional_data",
    user="your_username",
    password="your_password",
    host="localhost",
    port="5432"
)
cursor = conn.cursor()

# Generate Inventory Data
categories = ["Electronics", "Clothing", "Home Appliances", "Books"]
inventory_data = [
    (f"Product {i}", random.choice(categories), random.randint(10, 100), round(random.uniform(10.0, 500.0), 2))
    for i in range(1, 101)
]

cursor.executemany(
    "INSERT INTO inventory (product_name, category, stock_quantity, price) VALUES (%s, %s, %s, %s)",
    inventory_data
)

# Generate Sales Data
start_date = datetime(2023, 1, 1)
sales_data = []
for i in range(1000):
    order_date = start_date + timedelta(days=random.randint(0, 365))
    product_id = random.randint(1, 100)
    quantity = random.randint(1, 10)
    price = next(item[3] for item in inventory_data if item[0] == f"Product {product_id}")
    total_price = price * quantity
    sales_data.append((product_id, random.randint(1, 500), quantity, total_price, order_date))

cursor.executemany(
    "INSERT INTO sales (product_id, customer_id, quantity, total_price, order_date) VALUES (%s, %s, %s, %s, %s)",
    sales_data
)

conn.commit()
cursor.close()
conn.close()
