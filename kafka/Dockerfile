FROM confluentinc/cp-kafka:7.6.1

# Copy custom startup script
COPY --chmod=755 kafka-startup.sh /usr/local/bin/kafka-startup.sh

# Override the entrypoint to use our custom script
ENTRYPOINT ["/usr/local/bin/kafka-startup.sh"]
