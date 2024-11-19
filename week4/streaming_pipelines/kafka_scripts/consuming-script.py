import json
from kafka import KafkaConsumer

print("forming the consumer")
consumer = KafkaConsumer(
    'test-topic',
    bootstrap_servers='localhost:9092',
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

print("start consuming msgs")
for message in consumer:
    print(message.value)
