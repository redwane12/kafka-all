# 🚀 Apache Kafka - Guia Completo de Instalação e Uso

Este repositório contém uma configuração completa do Apache Kafka usando Docker, incluindo scripts de gerenciamento e exemplos de código.

## 📋 Pré-requisitos

- **Docker Desktop** instalado e rodando
- **Python 3.7+** (para os exemplos de código)
- **Windows 10/11** (scripts otimizados para Windows)

## 🏗️ Arquitetura da Configuração

A configuração inclui:
- **Zookeeper**: Gerenciamento de metadados do Kafka
- **Kafka Broker**: Servidor principal do Kafka
- **Kafka UI**: Interface web para gerenciamento (opcional)

## 🚀 Como Iniciar o Kafka

### Método 1: Script Automatizado (Recomendado)
```bash
# Execute o script de inicialização
start-kafka.bat
```

### Método 2: Docker Compose Manual
```bash
# Inicie os containers
docker-compose up -d

# Verifique se os containers estão rodando
docker-compose ps
```

## 🛑 Como Parar o Kafka

```bash
# Execute o script de parada
stop-kafka.bat

# Ou manualmente
docker-compose down
```

## 🌐 Acessos Disponíveis

Após iniciar o Kafka, você terá acesso a:

| Serviço | Endereço | Descrição |
|---------|----------|-----------|
| Kafka Broker | `localhost:9092` | Endpoint principal do Kafka |
| Zookeeper | `localhost:2181` | Coordenação de cluster |
| Kafka UI | `http://localhost:8080` | Interface web de gerenciamento |

## 🛠️ Ferramentas de Gerenciamento

### Script Interativo
Execute `kafka-tools.bat` para acessar um menu interativo com opções para:
1. ✅ Criar tópicos
2. 📋 Listar tópicos
3. 🗑️ Deletar tópicos
4. 📤 Enviar mensagens (Producer)
5. 📥 Consumir mensagens (Consumer)

### Comandos Manuais

#### Criar um Tópico
```bash
docker exec kafka kafka-topics --create --topic meu-topico --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
```

#### Listar Tópicos
```bash
docker exec kafka kafka-topics --list --bootstrap-server localhost:9092
```

#### Enviar Mensagens (Producer Console)
```bash
docker exec -it kafka kafka-console-producer --topic meu-topico --bootstrap-server localhost:9092
```

#### Consumir Mensagens (Consumer Console)
```bash
docker exec -it kafka kafka-console-consumer --topic meu-topico --bootstrap-server localhost:9092 --from-beginning
```

## 🐍 Exemplos em Python

### Instalação das Dependências
```bash
cd exemplos
pip install -r requirements.txt
```

### Producer (Enviar Mensagens)
```bash
python producer.py
```

O producer inclui:
- ✉️ Envio de mensagens simples
- 🔄 Geração automática de mensagens de teste
- 💬 Modo interativo para envio manual

### Consumer (Receber Mensagens)
```bash
python consumer.py
```

O consumer inclui:
- 🎧 Consumo contínuo de mensagens
- 📊 Processamento detalhado com metadados
- 🔍 Informações sobre partições e offsets

## 📚 Conceitos Importantes do Kafka

### 🏷️ Tópicos (Topics)
- Categorias onde as mensagens são organizadas
- Exemplo: `vendas`, `logs`, `eventos-usuario`

### 📦 Partições (Partitions)
- Divisões de um tópico para escalabilidade
- Permitem processamento paralelo

### 👥 Grupos de Consumidores (Consumer Groups)
- Conjunto de consumidores que trabalham juntos
- Cada mensagem é processada por apenas um consumidor do grupo

### 🔑 Chaves (Keys)
- Identificador opcional para garantir ordem
- Mensagens com a mesma chave vão para a mesma partição

## ⚙️ Configurações Importantes

### Configurações do Producer
```python
producer = KafkaProducer(
    bootstrap_servers=['localhost:9092'],
    value_serializer=lambda x: json.dumps(x).encode('utf-8'),
    key_serializer=lambda x: x.encode('utf-8'),
    acks='all',  # Aguarda confirmação de todas as réplicas
    retries=3,   # Tentativas em caso de falha
    batch_size=16384,  # Tamanho do lote para otimização
)
```

### Configurações do Consumer
```python
consumer = KafkaConsumer(
    'meu-topico',
    bootstrap_servers=['localhost:9092'],
    group_id='meu-grupo',
    auto_offset_reset='earliest',  # Lê desde o início
    enable_auto_commit=True,       # Confirma automaticamente
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)
```

## 🔧 Troubleshooting

### Problema: Containers não iniciam
```bash
# Verifique se as portas estão livres
netstat -an | findstr :9092
netstat -an | findstr :2181

# Remova containers antigos
docker-compose down -v
docker system prune -f
```

### Problema: Não consegue conectar no Kafka
1. ✅ Verifique se o Docker está rodando
2. ✅ Confirme que os containers estão UP: `docker-compose ps`
3. ✅ Teste a conectividade: `telnet localhost 9092`

### Problema: Mensagens não aparecem
1. ✅ Verifique se o tópico existe
2. ✅ Confirme o nome do tópico no producer e consumer
3. ✅ Use `--from-beginning` no consumer para ver mensagens antigas

## 📈 Monitoramento

### Kafka UI (Interface Web)
Acesse `http://localhost:8080` para:
- 📊 Visualizar tópicos e partições
- 📈 Monitorar throughput e lag
- 🔍 Inspecionar mensagens
- ⚙️ Gerenciar configurações

### Comandos de Monitoramento
```bash
# Informações do cluster
docker exec kafka kafka-broker-api-versions --bootstrap-server localhost:9092

# Status dos consumer groups
docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --list

# Detalhes de um consumer group
docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --group meu-grupo --describe
```

## 🎯 Casos de Uso Comuns

### 1. 📊 Streaming de Eventos
```python
# Producer para eventos de usuário
evento = {
    "usuario_id": 12345,
    "acao": "compra",
    "produto": "smartphone",
    "valor": 899.99,
    "timestamp": datetime.now().isoformat()
}
producer.send('eventos-usuario', value=evento)
```

### 2. 📝 Processamento de Logs
```python
# Consumer para processar logs
for mensagem in consumer:
    log_entry = mensagem.value
    if log_entry['level'] == 'ERROR':
        enviar_alerta(log_entry)
    salvar_no_banco(log_entry)
```

### 3. 🔄 Integração de Microserviços
```python
# Serviço A envia evento
evento_pedido = {
    "pedido_id": "PED-001",
    "status": "confirmado",
    "cliente_id": 456
}
producer.send('pedidos', value=evento_pedido)

# Serviço B processa evento
# (estoque, pagamento, entrega, etc.)
```

## 🚀 Próximos Passos

1. 📖 Estude a [documentação oficial do Kafka](https://kafka.apache.org/documentation/)
2. 🧪 Experimente com diferentes configurações de partições
3. 🔧 Implemente processamento de stream com Kafka Streams
4. 📊 Configure monitoramento com Prometheus + Grafana
5. 🔒 Adicione segurança (SSL/SASL)

## 📞 Suporte

Se encontrar problemas:
1. 🔍 Verifique os logs: `docker-compose logs kafka`
2. 📖 Consulte este README
3. 🌐 Acesse a documentação oficial do Apache Kafka

---

**🎉 Parabéns! Você agora tem uma instância completa do Apache Kafka rodando!**
"# kafka-all" 
