import json
from kafka import KafkaProducer

producer = KafkaProducer(
    bootstrap_servers='localhost:9092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

for i in range(100):
    producer.send(
        'test-topic', {'number': i}
    )
    producer.flush()

producer.close()