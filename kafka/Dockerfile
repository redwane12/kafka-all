# Usa a imagem oficial da Confluent
FROM confluentinc/cp-kafka:8.0.1

# Copia o nosso ficheiro de configuração para dentro da imagem
COPY custom.properties /etc/kafka/custom.properties

# Define o utilizador como root para que o CMD possa executar 'chown'
USER root

# Comando final que prepara as permissões e inicia o Kafka
# FORÇANDO o uso do nosso ficheiro de configuração.
CMD ["bash", "-c", "chown -R 1000:1000 /var/lib/kafka/data && kafka-server-start /etc/kafka/custom.properties"]
