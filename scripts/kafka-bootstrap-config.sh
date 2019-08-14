#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo "Initializing kafka..."
sleep 5

echo "Creating kafka topics..."
kafka-topics \
    --create \
    --if-not-exists \
    --zookeeper "${ZK_HOSTS}" \
    --topic "${KAFKA_TOPIC}" \
	--replication-factor 1 \
	--partitions 5 \
	--config retention.ms=-1

echo "Creating kafka consumer groups..."
kafka-consumer-groups \
    --zookeeper "${ZK_HOSTS}" \
    --group ${KAFKA_CONSUMER_GROUP}  \
    --reset-offsets \
    --to-earliest \
    --all-topics \
    --execute

echo "Creating cluster in kafka manager..."
for i in {1..5}; do
    curl -sX POST "http://kafka-manager:9000/clusters" \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -d "\
name=${CLUSTER_NAME}&\
zkHosts=${ZK_HOSTS}&\
kafkaVersion=${KAFKA_VERSION}&\
jmxUser=&\
jmxPass=&\
tuning.brokerViewUpdatePeriodSeconds=30&\
tuning.clusterManagerThreadPoolSize=2&\
tuning.clusterManagerThreadPoolQueueSize=100&\
tuning.kafkaCommandThreadPoolSize=2&\
tuning.kafkaCommandThreadPoolQueueSize=100&\
tuning.logkafkaCommandThreadPoolSize=2&\
tuning.logkafkaCommandThreadPoolQueueSize=100&\
tuning.logkafkaUpdatePeriodSeconds=30&\
tuning.partitionOffsetCacheTimeoutSecs=5&\
tuning.brokerViewThreadPoolSize=2&\
tuning.brokerViewThreadPoolQueueSize=1000&\
tuning.offsetCacheThreadPoolSize=2&\
tuning.offsetCacheThreadPoolQueueSize=1000&\
tuning.kafkaAdminClientThreadPoolSize=2&\
tuning.kafkaAdminClientThreadPoolQueueSize=1000&\
tuning.kafkaManagedOffsetMetadataCheckMillis=30000&\
tuning.kafkaManagedOffsetGroupCacheSize=1000000&\
tuning.kafkaManagedOffsetGroupExpireDays=7&\
securityProtocol=PLAINTEXT" > /dev/null && break

    if [ $i -eq "5" ]; then
        echo "Cluster creating failed"
        exit 1
    fi

    echo "Cluster creating failed, retrying in 5 seconds..."
    sleep 5
done

echo "Done!"
