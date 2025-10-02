# Usa a imagem oficial da Confluent
FROM confluentinc/cp-kafka:8.0.1

# Define o utilizador como root para que o CMD possa executar 'chown'.
USER root

# Define o comando de arranque.
# Preparamos as permissões e depois executamos o script oficial como root.
# O script irá baixar os privilégios internamente.
CMD ["bash", "-c", "mkdir -p /var/lib/kafka/data/kafka-logs && chown -R 1000:1000 /var/lib/kafka/data && /etc/confluent/docker/run"]
