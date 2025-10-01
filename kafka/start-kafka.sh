#!/bin/bash

# =================================================================
# Script de inicialização do Kafka com autenticação SASL/SCRAM
# =================================================================

set -e

# Função para aguardar o Zookeeper estar disponível
wait_for_zookeeper() {
    echo "Aguardando Zookeeper estar disponível..."
    echo "Tentando conectar em: $KAFKA_ZOOKEEPER_CONNECT"
    
    local count=0
    while [ $count -lt 30 ]; do
        if nc -z ${KAFKA_ZOOKEEPER_CONNECT%:*} 2181 2>/dev/null; then
            echo "Zookeeper está disponível!"
            return 0
        fi
        echo "Tentativa $((count + 1))/30 - Zookeeper não está disponível - aguardando..."
        sleep 2
        count=$((count + 1))
    done
    
    echo "Zookeeper não ficou disponível após 60 segundos, continuando mesmo assim..."
}

# Função para criar arquivo JAAS (apenas para Kafka)
create_jaas_config() {
    echo "Criando configuração JAAS apenas para Kafka..."
    
    cat > /etc/kafka/secrets/kafka_server_jaas.conf << 'JAAS_EOF'
KafkaServer {
    org.apache.kafka.common.security.scram.ScramLoginModule required
    username="admin"
    password="admin-secret";
};
JAAS_EOF
    
    echo "Arquivo JAAS criado com sucesso!"
}

# Função para criar usuários SCRAM
create_scram_users() {
    echo "Criando usuários SCRAM..."
    
    # Aguardar o Kafka estar rodando
    sleep 15
    
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

# Função para configurar ACLs
configure_acls() {
    echo "Configurando ACLs..."
    
    # Aguardar o Kafka estar rodando
    sleep 20
    
    if [ ! -z "$API_KEY" ]; then
        # Dar permissões para o usuário da API usando a porta interna
        kafka-acls --bootstrap-server localhost:29092 \
            --add \
            --allow-principal User:$API_KEY \
            --operation All \
            --topic '*' \
            --group '*' || echo "Erro ao configurar ACLs"
    fi
}

# Aguardar Zookeeper
wait_for_zookeeper

# Criar configuração JAAS
create_jaas_config

# Executar funções em background
configure_acls &
create_scram_users &

# Exportar variável apenas para o processo Kafka
export KAFKA_OPTS="-Djava.security.auth.login.config=/etc/kafka/secrets/kafka_server_jaas.conf"

# Iniciar o Kafka
echo "Iniciando Kafka com autenticação SASL/SCRAM..."
exec /etc/confluent/docker/run
