FROM confluentinc/cp-kafka:7.6.1

# Install necessary tools
RUN apt-get update && apt-get install -y sudo

# Allow appuser to execute cleanup commands
RUN echo "appuser ALL=(root) NOPASSWD: /bin/rm, /bin/chown, /bin/chmod, /bin/mkdir" > /etc/sudoers.d/appuser

# Add init scripts with proper permissions
COPY --chmod=755 init-kafka.sh /docker-entrypoint-initdb.d/init-kafka.sh
COPY --chmod=755 wrapper.sh /usr/local/bin/wrapper.sh

ENTRYPOINT ["wrapper.sh"]
CMD ["/etc/confluent/docker/run"]
