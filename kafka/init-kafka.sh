#!/bin/bash

echo "Initializing Kafka data directory..."

# Create the data directory if it doesn't exist
sudo mkdir -p /var/lib/kafka/data

# Remove lost+found directory if it exists in the Kafka data path
if [ -d "/var/lib/kafka/data/lost+found" ]; then
    echo "Removing lost+found directory from Kafka data path..."
    sudo rm -rf "/var/lib/kafka/data/lost+found"
fi

# Set proper permissions
sudo chown -R appuser:appuser /var/lib/kafka/data
sudo chmod -R 755 /var/lib/kafka/data

# Create a marker file to indicate initialization
sudo touch /var/lib/kafka/data/.kafka_initialized
sudo chown appuser:appuser /var/lib/kafka/data/.kafka_initialized

echo "Kafka data directory initialized successfully."
