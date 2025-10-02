#!/bin/bash

echo "=== Kafka Startup Script ==="

# Create Kafka-specific subdirectory
KAFKA_LOG_DIR="/var/lib/kafka/data/kafka-logs"
mkdir -p $KAFKA_LOG_DIR

# Set proper permissions
chown -R appuser:appuser /var/lib/kafka/data
chmod -R 755 /var/lib/kafka/data

# Export the environment variable
export KAFKA_LOG_DIRS=$KAFKA_LOG_DIR

echo "Kafka logs directory: $KAFKA_LOG_DIRS"

# Start Kafka using the original Confluent entrypoint
echo "Starting Kafka..."
exec /etc/confluent/docker/run
