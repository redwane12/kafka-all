FROM confluentinc/cp-kafka:7.6.1

# Use subdirectory específico para dados do Kafka dentro do volume
ENV KAFKA_LOG_DIRS=/var/lib/kafka/data/kafka-storage

# Mude para o utilizador root temporariamente para poder alterar as permissões
USER root

# Crie o diretório (se não existir) e dê a propriedade ao utilizador 'appuser' (UID 1000)
# O -R (recursivo) garante que tudo dentro do diretório também terá as permissões corretas.
RUN mkdir -p /var/lib/kafka/data && chown -R 1000:1000 /var/lib/kafka/data

# Volte para o utilizador não-root por segurança
USER 1000
