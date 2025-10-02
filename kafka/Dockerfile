FROM confluentinc/cp-kafka:7.6.1

# Add init scripts with proper permissions
COPY --chmod=755 init-kafka.sh /docker-entrypoint-initdb.d/init-kafka.sh
COPY --chmod=755 wrapper.sh /usr/local/bin/wrapper.sh

# Switch to root for initialization, then back to appuser
USER root

ENTRYPOINT ["wrapper.sh"]
CMD ["/etc/confluent/docker/run"]
