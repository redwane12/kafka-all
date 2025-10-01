#!/bin/bash

# =================================================================
# Script de inicialização SIMPLIFICADO do Kafka
# =================================================================

set -e

# **CRÍTICO: Desabilitar SASL para ZooKeeper Client**
export KAFKA_OPTS="-Djava.security.auth.login.config=/etc/kafka/secrets/kafka_server_jaas.conf -Dzookeeper.sasl.client=false"

# Criar configuração JAAS apenas para Kafka
echo "Criando configuração JAAS apenas para Kafka..."
mkdir -p /etc/kafka/secrets

cat > /etc/kafka/secrets/kafka_server_jaas.conf << 'JAAS_EOF'
KafkaServer {
    org.apache.kafka.common.security.scram.ScramLoginModule required
    username="admin"
    password="admin-secret";
};
JAAS_EOF

echo "Arquivo JAAS criado com sucesso!"

# Função para configuração pós-inicialização
setup_after_start() {
    echo "Aguardando Kafka iniciar (30 segundos)..."
    sleep 30
    
    # Tentar criar usuário SCRAM
    if [ ! -z "$API_KEY" ] && [ ! -z "$API_SECRET" ]; then
        echo "Tentando criar usuário SCRAM: $API_KEY"
        
        # Método 1: Via Zookeeper (mais confiável no início)
        kafka-configs --zookeeper "$KAFKA_ZOOKEEPER_CONNECT" \
            --alter \
            --add-config "SCRAM-SHA-256=[password=$API_SECRET],SCRAM-SHA-512=[password=$API_SECRET]" \
            --entity-type users \
            --entity-name "$API_KEY" || echo "Usuário já existe ou erro na criação"
    fi
}

# Executar setup em background
setup_after_start &

# Iniciar o Kafka
echo "Iniciando Kafka..."
exec /etc/confluent/docker/run
