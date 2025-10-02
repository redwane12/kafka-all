# Usa a imagem oficial da Confluent
FROM confluentinc/cp-kafka:8.0.1

# Substitui o ficheiro de configuração padrão pelo nosso
COPY server.properties /etc/kafka/server.properties

# Define o utilizador como root para que o CMD possa executar 'chown'
USER root

# Prepara as permissões e executa o script oficial.
# O script agora irá ler o nosso server.properties modificado.
CMD ["bash", "-c", "chown -R 1000:1000 /var/lib/kafka/data && /etc/confluent/docker/run"]
