FROM provectuslabs/kafka-ui:latest

# Configurações específicas para Railway
ENV KAFKA_CLUSTERS_0_NAME=${KAFKA_CLUSTERS_0_NAME:-railway-kafka}
ENV KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=${KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS:-kafka:9092}
ENV KAFKA_CLUSTERS_0_ZOOKEEPER=${KAFKA_CLUSTERS_0_ZOOKEEPER:-zookeeper:2181}

# Expor porta padrão
EXPOSE 8080

# Railway usa PORT como variável de ambiente
CMD ["sh", "-c", "export SERVER_PORT=${PORT:-8080} && java $JAVA_OPTS -jar kafka-ui-api.jar"]
