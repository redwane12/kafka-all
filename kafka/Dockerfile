# =================================================================
# Dockerfile para Kafka Broker
# =================================================================
# Imagem base oficial da Confluent.
FROM confluentinc/cp-kafka:7.6.1

# Criar diretório para configurações de segurança
RUN mkdir -p /etc/kafka/secrets

# Copiar script de inicialização
COPY start-kafka.sh /start-kafka.sh
RUN chmod +x /start-kafka.sh

# Expõe as portas:
# 9092: Para comunicação interna (PLAINTEXT)
# 29092: Para comunicação externa (PLAINTEXT)
# 9093: Para comunicação com autenticação SASL/SCRAM
EXPOSE 9092 29092 9093

# Usar script de inicialização personalizado
CMD ["/start-kafka.sh"]
