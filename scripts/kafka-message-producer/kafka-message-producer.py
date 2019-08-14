import sys
import json
import random

from kafka import KafkaProducer

TOPIC = "example_topic"

producer = KafkaProducer(
    bootstrap_servers="localhost:9092",
    key_serializer=str.encode,
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

id_opts = {'1': ['A', 'B', 'C', 'D', 'E'], '2': ['F', 'G', 'H', 'I', 'J']}
ids = id_opts[sys.argv[1]]

for i in range(1000000):
    message = {
        'id': random.choice(ids),
        'num': i + 1,
        'exq': random.random() < 0.3,
    }
    print(f"Sending {message} to kafka...")
    future = producer.send(TOPIC, key=message['id'], value=message)
    result = future.get(timeout=60)
    print("Done!")
