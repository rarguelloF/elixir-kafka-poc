# Elixir Kafka PoC

A sample project testing Elixir and Kafka integration using [kafka_ex](https://github.com/kafkaex/kafka_ex)

## Getting started

1. Start dependencies (including kafka):

```sh
docker-compose up
```

2. Start elixir application (kafka consumer):

```sh
mix deps.get

iex -S mix run
```

3. Start 2 producers in parallel (requires Python):

```
cd scripts/kafka-message-producer
pip install -r requirements.txt

python kafka-message-producer.py 1
python kafka-message-producer.py 2
```

