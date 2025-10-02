#!/bin/bash

# Execute the Kafka initialization script
if [ -f "/docker-entrypoint-initdb.d/init-kafka.sh" ]; then
    echo "Running Kafka initialization script..."
    /docker-entrypoint-initdb.d/init-kafka.sh
fi

# Execute the original command
exec "$@"
