# Usa a imagem oficial da Confluent
FROM confluentinc/cp-kafka:8.0.1

# Define o utilizador como root para que o CMD possa executar 'chown'.
USER root

# Comando atualizado para limpar o diretório antes de iniciar.
CMD ["bash", "-c", "rm -rf /var/lib/kafka/data/kafka-logs && mkdir -p /var/lib/kafka/data/kafka-logs && chown -R 1000:1000 /var/lib/kafka/data && /etc/confluent/docker/run"]
