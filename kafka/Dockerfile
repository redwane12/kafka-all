FROM confluentinc/cp-kafka:7.6.1

# Copy custom startup script
COPY --chmod=755 kafka-startup.sh /usr/local/bin/kafka-startup.sh

# Set environment variable for Kafka logs directory
ENV KAFKA_LOG_DIRS=/var/lib/kafka/data/kafka-logs

ENTRYPOINT ["/usr/local/bin/kafka-startup.sh"]
