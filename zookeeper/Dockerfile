FROM confluentinc/cp-zookeeper:7.4.0

# Configurações específicas para Railway
ENV ZOOKEEPER_CLIENT_PORT=${ZOOKEEPER_CLIENT_PORT:-2181}
ENV ZOOKEEPER_TICK_TIME=${ZOOKEEPER_TICK_TIME:-2000}

# Expor porta padrão
EXPOSE 2181

# Railway usa PORT como variável de ambiente padrão
CMD ["sh", "-c", "export ZOOKEEPER_CLIENT_PORT=${PORT:-2181} && /etc/confluent/docker/run"]
