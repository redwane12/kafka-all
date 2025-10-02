# Usa a imagem oficial da Confluent
FROM confluentinc/cp-kafka:8.0.1

# Define o utilizador como root para que o CMD possa executar 'chown'
USER root

# Prepara as permissões e executa o script oficial.
CMD ["bash", "-c", "chown -R 1000:1000 /var/lib/kafka/data && /etc/confluent/docker/run"]
