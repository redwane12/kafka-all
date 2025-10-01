#!/bin/bash

# =================================================================
# Script FINAL para Kafka - Foco: Usuário externo com SASL/SCRAM
# =================================================================

set -e

# Desabilitar SASL para ZooKeeper Client
export KAFKA_OPTS="-Djava.security.auth.login.config=/etc/kafka/secrets/kafka_server_jaas.conf -Dzookeeper.sasl.client=false"

# Criar configuração JAAS apenas para Kafka
echo "Criando configuração JAAS para Kafka..."
mkdir -p /etc/kafka/secrets

cat > /etc/kafka/secrets/kafka_server_jaas.conf << 'JAAS_EOF'
KafkaServer {
    org.apache.kafka.common.security.scram.ScramLoginModule required
    username="admin"
    password="admin-secret";
};
JAAS_EOF

echo "✅ Arquivo JAAS criado"

# Tentar criar usuário SCRAM apenas se Zookeeper estiver disponível rapidamente
if [ ! -z "$API_KEY" ] && [ ! -z "$API_SECRET" ]; then
    echo "Tentando criar usuário SCRAM: $API_KEY"
    
    # Tentativa rápida - se não conseguir em 10s, pula
    if timeout 10s bash -c "until nc -z ${KAFKA_ZOOKEEPER_CONNECT%:*} 2181; do sleep 1; done"; then
        echo "✅ Zookeeper disponível, criando usuário..."
        kafka-configs --zookeeper "$KAFKA_ZOOKEEPER_CONNECT" \
            --alter \
            --add-config "SCRAM-SHA-256=[password=$API_SECRET],SCRAM-SHA-512=[password=$API_SECRET]" \
            --entity-type users \
            --entity-name "$API_KEY"
        echo "✅ Usuário SCRAM criado: $API_KEY"
    else
        echo "⚠️  Zookeeper não disponível rapidamente, usuário será criado manualmente depois"
        echo "⚠️  Execute manualmente depois:"
        echo "kafka-configs --bootstrap-server localhost:29092 --alter --add-config 'SCRAM-SHA-256=[password=$API_SECRET]' --entity-type users --entity-name $API_KEY"
    fi
fi

echo "🚀 Iniciando Kafka Broker..."
echo "📝 Configure ACLs manualmente depois com:"
echo "kafka-acls --bootstrap-server localhost:29092 --add --allow-principal User:$API_KEY --operation All --topic '*' --group '*' --force"

# Iniciar o Kafka
exec /etc/confluent/docker/run
