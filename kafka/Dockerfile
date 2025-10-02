# =================================================================
# Dockerfile para Kafka Broker
# =================================================================
# Imagem base oficial da Confluent.
FROM confluentinc/cp-kafka:7.6.1

# Expõe as duas portas que configuraremos:
# 9092: Para comunicação interna dentro da rede privada (container para container).
# 29092: Para comunicação externa (de fora da rede, se necessário).
EXPOSE 9092 29092

# Cria diretório para dados do Kafka
RUN mkdir -p /var/lib/kafka/data

# Define o volume para persistência de dados
VOLUME ["/var/lib/kafka/data"]
