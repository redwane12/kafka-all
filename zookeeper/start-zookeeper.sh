#!/bin/bash

# Forçar porta 2181 para Zookeeper (Railway pode atribuir 8080)
export ZOOKEEPER_CLIENT_PORT=2181
export ZOOKEEPER_TICK_TIME=${ZOOKEEPER_TICK_TIME:-2000}

# Log da configuração
echo "Starting Zookeeper on port: $ZOOKEEPER_CLIENT_PORT"
echo "Railway assigned PORT: $PORT (ignored, using 2181)"
echo "Tick time: $ZOOKEEPER_TICK_TIME"

# Iniciar Zookeeper
exec /etc/confluent/docker/run
