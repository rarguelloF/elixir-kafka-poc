SHELL := /bin/bash

COMPOSE_SERVICE_KAFKA := kafka
COMPOSE_SERVICE_ZOOKEEPER := zookeeper

KAFKA_TOPIC := example_topic
KAFKA_GROUP := example_group

kafka-consumer:
	docker-compose exec ${COMPOSE_SERVICE_KAFKA} \
		kafka-console-consumer \
			--bootstrap-server localhost:9092 \
			--topic ${KAFKA_TOPIC} \
			--new-consumer \
			--from-beginning
.PHONY: kafka-consumer

kafka-reset-offsets:
	docker-compose exec ${COMPOSE_SERVICE_KAFKA} \
		kafka-consumer-groups \
			--zookeeper zookeeper:32181 \
			--group ${KAFKA_GROUP}  \
			--reset-offsets \
			--to-earliest \
			--all-topics \
			--execute
.PHONY: kafka-reset-offsets

kafka-create-topics:
	docker-compose exec ${COMPOSE_SERVICE_KAFKA} \
		kafka-topics \
			--zookeeper ${COMPOSE_SERVICE_ZOOKEEPER}:2181 \
			--create \
			--topic ${KAFKA_TOPIC} \
			--replication-factor 1 \
			--partitions 5 \
			--config retention.ms=-1
.PHONY: kafka-create-topics

kafka-configure-topics:
	docker-compose exec ${COMPOSE_SERVICE_KAFKA} \
		kafka-topics \
			--zookeeper ${COMPOSE_SERVICE_ZOOKEEPER}:2181 \
			--alter \
			--topic ${KAFKA_TOPIC} \
			--partitions 5
.PHONY: kafka-configure-topics

kafka-delete-topics:
	docker-compose exec ${COMPOSE_SERVICE_KAFKA} \
		kafka-topics
			--zookeeper ${COMPOSE_SERVICE_ZOOKEEPER}:2181 \
			--delete \
			--topic ${KAFKA_TOPIC}
.PHONY: kafka-delete-topics
