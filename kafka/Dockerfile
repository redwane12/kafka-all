# =================================================================
# Dockerfile para Kafka Broker
# =================================================================
# Imagem base oficial da Confluent.
FROM confluentinc/cp-kafka:7.6.1

# Criar diretório para configurações de segurança
RUN mkdir -p /etc/kafka/secrets

# Criar script de inicialização
RUN echo '#!/bin/bash' > /start-kafka.sh && \
    echo 'set -e' >> /start-kafka.sh && \
    echo '' >> /start-kafka.sh && \
    echo '# Função para aguardar o Zookeeper estar disponível' >> /start-kafka.sh && \
    echo 'wait_for_zookeeper() {' >> /start-kafka.sh && \
    echo '    echo "Aguardando Zookeeper estar disponível..."' >> /start-kafka.sh && \
    echo '    until nc -z $KAFKA_ZOOKEEPER_CONNECT; do' >> /start-kafka.sh && \
    echo '        echo "Zookeeper não está disponível - aguardando..."' >> /start-kafka.sh && \
    echo '        sleep 2' >> /start-kafka.sh && \
    echo '    done' >> /start-kafka.sh && \
    echo '    echo "Zookeeper está disponível!"' >> /start-kafka.sh && \
    echo '}' >> /start-kafka.sh && \
    echo '' >> /start-kafka.sh && \
    echo '# Função para criar usuários SCRAM' >> /start-kafka.sh && \
    echo 'create_scram_users() {' >> /start-kafka.sh && \
    echo '    echo "Criando usuários SCRAM..."' >> /start-kafka.sh && \
    echo '    sleep 10' >> /start-kafka.sh && \
    echo '    ' >> /start-kafka.sh && \
    echo '    if [ ! -z "$API_KEY" ] && [ ! -z "$API_SECRET" ]; then' >> /start-kafka.sh && \
    echo '        echo "Criando usuário SCRAM: $API_KEY"' >> /start-kafka.sh && \
    echo '        kafka-configs --zookeeper $KAFKA_ZOOKEEPER_CONNECT \' >> /start-kafka.sh && \
    echo '            --alter \' >> /start-kafka.sh && \
    echo '            --add-config "SCRAM-SHA-256=[password=$API_SECRET],SCRAM-SHA-512=[password=$API_SECRET]" \' >> /start-kafka.sh && \
    echo '            --entity-type users \' >> /start-kafka.sh && \
    echo '            --entity-name $API_KEY || echo "Usuário já existe ou erro na criação"' >> /start-kafka.sh && \
    echo '    fi' >> /start-kafka.sh && \
    echo '}' >> /start-kafka.sh && \
    echo '' >> /start-kafka.sh && \
    echo '# Função para criar arquivo JAAS' >> /start-kafka.sh && \
    echo 'create_jaas_config() {' >> /start-kafka.sh && \
    echo '    echo "Criando configuração JAAS..."' >> /start-kafka.sh && \
    echo '    ' >> /start-kafka.sh && \
    echo '    cat > /etc/kafka/secrets/kafka_server_jaas.conf << EOF' >> /start-kafka.sh && \
    echo 'KafkaServer {' >> /start-kafka.sh && \
    echo '    org.apache.kafka.common.security.scram.ScramLoginModule required' >> /start-kafka.sh && \
    echo '    username="admin"' >> /start-kafka.sh && \
    echo '    password="admin-secret";' >> /start-kafka.sh && \
    echo '};' >> /start-kafka.sh && \
    echo '' >> /start-kafka.sh && \
    echo 'Client {' >> /start-kafka.sh && \
    echo '    org.apache.kafka.common.security.scram.ScramLoginModule required' >> /start-kafka.sh && \
    echo '    username="admin"' >> /start-kafka.sh && \
    echo '    password="admin-secret";' >> /start-kafka.sh && \
    echo '};' >> /start-kafka.sh && \
    echo 'EOF' >> /start-kafka.sh && \
    echo '}' >> /start-kafka.sh && \
    echo '' >> /start-kafka.sh && \
    echo '# Função para configurar ACLs' >> /start-kafka.sh && \
    echo 'configure_acls() {' >> /start-kafka.sh && \
    echo '    echo "Configurando ACLs..."' >> /start-kafka.sh && \
    echo '    sleep 15' >> /start-kafka.sh && \
    echo '    ' >> /start-kafka.sh && \
    echo '    if [ ! -z "$API_KEY" ]; then' >> /start-kafka.sh && \
    echo '        kafka-acls --bootstrap-server localhost:9092 \' >> /start-kafka.sh && \
    echo '            --add \' >> /start-kafka.sh && \
    echo '            --allow-principal User:$API_KEY \' >> /start-kafka.sh && \
    echo '            --operation All \' >> /start-kafka.sh && \
    echo '            --topic "*" \' >> /start-kafka.sh && \
    echo '            --group "*" || echo "Erro ao configurar ACLs"' >> /start-kafka.sh && \
    echo '    fi' >> /start-kafka.sh && \
    echo '}' >> /start-kafka.sh && \
    echo '' >> /start-kafka.sh && \
    echo '# Executar funções em background' >> /start-kafka.sh && \
    echo 'configure_acls &' >> /start-kafka.sh && \
    echo 'create_scram_users &' >> /start-kafka.sh && \
    echo '' >> /start-kafka.sh && \
    echo '# Aguardar Zookeeper' >> /start-kafka.sh && \
    echo 'wait_for_zookeeper' >> /start-kafka.sh && \
    echo '' >> /start-kafka.sh && \
    echo '# Criar configuração JAAS' >> /start-kafka.sh && \
    echo 'create_jaas_config' >> /start-kafka.sh && \
    echo '' >> /start-kafka.sh && \
    echo '# Iniciar o Kafka' >> /start-kafka.sh && \
    echo 'echo "Iniciando Kafka..."' >> /start-kafka.sh && \
    echo 'exec /etc/confluent/docker/run' >> /start-kafka.sh

# Tornar o script executável
RUN chmod +x /start-kafka.sh

# Expõe as portas:
# 9092: Para comunicação interna (PLAINTEXT)
# 29092: Para comunicação externa (PLAINTEXT)
# 9093: Para comunicação com autenticação SASL/SCRAM
EXPOSE 9092 29092 9093

# Usar script de inicialização personalizado
CMD ["/start-kafka.sh"]
