#!/bin/bash

# =================================================================
# Script de inicialização do Kafka com autenticação SASL/SCRAM
# =================================================================

set -e

# Função para aguardar o Zookeeper estar disponível
wait_for_zookeeper() {
    echo "Aguardando Zookeeper estar disponível..."
    until nc -z $KAFKA_ZOOKEEPER_CONNECT; do
        echo "Zookeeper não está disponível - aguardando..."
        sleep 2
    done
    echo "Zookeeper está disponível!"
}

# Função para criar usuários SCRAM
create_scram_users() {
    echo "Criando usuários SCRAM..."
    
    # Aguardar o Kafka estar rodando
    sleep 10
    
    # Criar usuário com API_KEY e API_SECRET
    if [ ! -z "$API_KEY" ] && [ ! -z "$API_SECRET" ]; then
        echo "Criando usuário SCRAM: $API_KEY"
        kafka-configs --zookeeper $KAFKA_ZOOKEEPER_CONNECT \
            --alter \
            --add-config 'SCRAM-SHA-256=[password='$API_SECRET'],SCRAM-SHA-512=[password='$API_SECRET']' \
            --entity-type users \
            --entity-name $API_KEY || echo "Usuário já existe ou erro na criação"
    fi
}

# Função para criar arquivo JAAS
create_jaas_config() {
    echo "Criando configuração JAAS..."
    
    cat > /etc/kafka/secrets/kafka_server_jaas.conf << EOF
KafkaServer {
    org.apache.kafka.common.security.scram.ScramLoginModule required
    username="admin"
    password="admin-secret";
};

Client {
    org.apache.kafka.common.security.scram.ScramLoginModule required
    username="admin"
    password="admin-secret";
};
EOF
}

# Função para configurar ACLs
configure_acls() {
    echo "Configurando ACLs..."
    
    # Aguardar o Kafka estar rodando
    sleep 15
    
    if [ ! -z "$API_KEY" ]; then
        # Dar permissões para o usuário da API
        kafka-acls --bootstrap-server localhost:9092 \
            --add \
            --allow-principal User:$API_KEY \
            --operation All \
            --topic '*' \
            --group '*' || echo "Erro ao configurar ACLs"
    fi
}

# Executar funções em background
configure_acls &
create_scram_users &

# Aguardar Zookeeper
wait_for_zookeeper

# Criar configuração JAAS
create_jaas_config

# Iniciar o Kafka
echo "Iniciando Kafka..."
exec /etc/confluent/docker/run