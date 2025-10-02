#!/bin/bash

echo "=== Kafka Startup Script ==="

# Ensure data directory exists
mkdir -p /var/lib/kafka/data

# Remove lost+found directory if it exists
if [ -d "/var/lib/kafka/data/lost+found" ]; then
    echo "Removing problematic lost+found directory..."
    rm -rf "/var/lib/kafka/data/lost+found"
fi

# Set proper permissions
chown -R appuser:appuser /var/lib/kafka/data
chmod -R 755 /var/lib/kafka/data

echo "Kafka data directory cleaned and ready."

# Start Kafka using the original Confluent entrypoint
echo "Starting Kafka..."
exec /etc/confluent/docker/run
