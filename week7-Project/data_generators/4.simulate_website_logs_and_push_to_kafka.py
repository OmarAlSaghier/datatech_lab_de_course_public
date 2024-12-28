from kafka import KafkaProducer
import json
import random
from datetime import datetime

producer = KafkaProducer(
    bootstrap_servers="localhost:9092",
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

actions = ["view", "click", "purchase"]

while True:
    log = {
        "user_id": random.randint(1, 500),
        "action": random.choice(actions),
        "product_id": random.randint(1, 100),
        "timestamp": datetime.now().isoformat()
    }
    producer.send("website_logs", value=log)
    print(f"Sent: {log}")
