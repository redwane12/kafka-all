#!/bin/bash

# =================================================================
# Script de inicialização do Kafka com autenticação SASL/SCRAM
# =================================================================

set -e

# Função para aguardar o Zookeeper estar disponível

# Função para criar usuários SCRAM (desabilitada por enquanto)
create_scram_users() {
    echo "Criação de usuários SCRAM desabilitada para simplificar configuração..."
    # Usuários SCRAM serão configurados manualmente se necessário
}

# Função para criar arquivo JAAS (desabilitada por enquanto)
create_jaas_config() {
    echo "Configuração JAAS desabilitada para evitar conflitos com Zookeeper..."
    # Arquivo JAAS não será criado para evitar problemas de SASL com Zookeeper
}

# Função para configurar ACLs (desabilitada por enquanto)
configure_acls() {
    echo "Configuração de ACLs desabilitada para simplificar configuração..."
    # ACLs serão configuradas manualmente se necessário
}

# Aguardar Zookeeper

# Executar funções em background (desabilitadas)
configure_acls &
create_scram_users &

# Criar configuração JAAS (desabilitada)
create_jaas_config

# Iniciar o Kafka
echo "Iniciando Kafka..."
exec /etc/confluent/docker/run
