FROM confluentinc/cp-zookeeper:7.4.0

# Configurações específicas para Railway
ENV ZOOKEEPER_TICK_TIME=2000
ENV ZOOKEEPER_CLIENT_PORT=2181

# Expor porta padrão do Zookeeper
EXPOSE 2181

# Script de inicialização para Railway
COPY start-zookeeper.sh /start-zookeeper.sh

CMD ["sh", "/start-zookeeper.sh"]
