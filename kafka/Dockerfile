# Usa a imagem oficial da Confluent
FROM confluentinc/cp-kafka:8.0.1

# Define o utilizador como root. É essencial para que o comando
# de arranque (CMD) possa executar 'chown'.
USER root

# Define o comando que será executado quando o contentor arrancar.
# Este comando combina todas as etapas necessárias.
CMD ["bash", "-c", "mkdir -p /var/lib/kafka/data/kafka-logs && chown -R 1000:1000 /var/lib/kafka/data && exec /usr/sbin/gosu 1000:1000 /etc/confluent/docker/run"]
