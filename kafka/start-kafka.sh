#!/bin/bash

# Configurar listeners dinamicamente para Railway
export KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://kafka:29092,PLAINTEXT_HOST://${RAILWAY_PUBLIC_DOMAIN:-localhost}:${PORT:-9092}"
export KAFKA_LISTENERS="PLAINTEXT://0.0.0.0:29092,PLAINTEXT_HOST://0.0.0.0:${PORT:-9092}"

# Iniciar Kafka
exec /etc/confluent/docker/run
