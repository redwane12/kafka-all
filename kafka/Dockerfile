# =================================================================
# Dockerfile para Kafka Broker
# =================================================================
FROM confluentinc/cp-kafka:7.6.1

EXPOSE 9092 29092

# Cria diretório e define permissões amplas
RUN mkdir -p /var/lib/kafka/data && \
    chmod -R 777 /var/lib/kafka/data

# Define para executar como root para evitar problemas de permissão
USER root
