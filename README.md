Com certeza\! Baseado em toda a nossa jornada de troubleshooting, preparei um `README.md` completo.

Este guia é o resultado final de tudo o que aprendemos e representa a forma correta e robusta de configurar um broker Kafka moderno (modo KRaft) e o Kafka UI na plataforma Railway.

Pode copiar e colar o conteúdo abaixo diretamente num ficheiro `README.md` no seu repositório do GitHub.

-----

# Configurando um Broker Kafka (KRaft) e Kafka UI no Railway

Este guia detalha o processo passo a passo para fazer o deploy de um broker Kafka moderno, em modo KRaft (sem Zookeeper), na plataforma Railway. Inclui também a configuração de um serviço [Kafka UI](https://github.com/provectus/kafka-ui) para gerir e visualizar o seu cluster Kafka.

## O Que Vamos Configurar?

1.  **Serviço Kafka**: Um único nó Kafka a correr como broker e controller (modo KRaft).
2.  **Volume Persistente**: Para garantir que os dados do Kafka não se perdem entre deploys.
3.  **Serviço Kafka UI**: Uma interface web para interagir com o nosso broker Kafka.

-----

## 1\. Configurando o Serviço Kafka

Esta é a parte principal, onde configuramos o broker Kafka.

### \#\#\# Passo 1: Criar o `Dockerfile`

Na raiz do seu projeto, crie um ficheiro chamado `Dockerfile` com o seguinte conteúdo. Este ficheiro é responsável por preparar o ambiente e garantir que as permissões do volume são corrigidas antes de iniciar o Kafka.

```dockerfile
# 1. Usar a imagem oficial da Confluent
FROM confluentinc/cp-kafka:8.0.1

# 2. Definir o utilizador como root.
#    Isto é essencial para que o comando de arranque (CMD)
#    possa corrigir as permissões do volume montado pelo Railway.
USER root

# 3. Definir o comando de arranque.
#    - 'chown' corrige a propriedade do diretório de dados para o utilizador 1000 (appuser).
#    - '/etc/confluent/docker/run' é o script oficial que lê as variáveis de ambiente
#      e inicia o Kafka corretamente, baixando os privilégios internamente.
CMD ["bash", "-c", "chown -R 1000:1000 /var/lib/kafka/data && /etc/confluent/docker/run"]
```

### \#\#\# Passo 2: Criar e Configurar o Serviço no Railway

1.  **Crie o Serviço**: No seu dashboard do Railway, crie um novo serviço a partir do seu repositório do GitHub.
2.  **Adicione um Volume Persistente**:
      * Com o serviço selecionado, vá para a aba **"Volumes"**.
      * Clique em **"Add Volume"**.
      * Configure o "Mount Path" para `/var/lib/kafka/data`.

### \#\#\# Passo 3: Gerar o `CLUSTER_ID`

O modo KRaft requer um ID de cluster único. Execute o seguinte comando no seu terminal (precisa do Docker instalado) para gerar um:

```bash
docker run --rm confluentinc/cp-kafka:latest kafka-storage.sh random-uuid
```

Copie o ID gerado (ex: `MkU3OEVBNTcwNTJENDM2Qk`). Vai precisar dele no próximo passo.

### \#\#\# Passo 4: Configurar as Variáveis de Ambiente

Vá para a aba **"Variables"** do seu serviço Kafka e adicione as seguintes variáveis. Esta é a configuração definitiva e correta para o modo KRaft.

| Nome da Variável                                  | Valor                                                                     |
| ---------------------------------------------- | ------------------------------------------------------------------------- |
| **`KAFKA_PROCESS_ROLES`** | `broker,controller`                                                       |
| **`KAFKA_NODE_ID`** | `1`                                                                       |
| **`KAFKA_CONTROLLER_QUORUM_VOTERS`** | `1@localhost:9093`                                                        |
| **`KAFKA_LISTENERS`** | `PLAINTEXT://:9092,CONTROLLER://:9093`                                    |
| **`KAFKA_ADVERTISED_LISTENERS`** | `PLAINTEXT://your-service-name.up.railway.app:9092`                     |
| **`KAFKA_LISTENER_SECURITY_PROTOCOL_MAP`** | `PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT`                                |
| **`KAFKA_INTER_BROKER_LISTENER_NAME`** | `PLAINTEXT`                                                               |
| **`KAFKA_CONTROLLER_LISTENER_NAMES`** | `CONTROLLER`                                                              |
| **`KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR`** | `1`                                                                       |
| **`KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR`** | `1`                                                                 |
| **`CLUSTER_ID`** | **\<Cole aqui o seu ID gerado no Passo 3\>** |
| **`KAFKA_LOG_DIRS`** | `/var/lib/kafka/data/kafka-logs`                                          |

> **‼️ MUITO IMPORTANTE: Atualize o `KAFKA_ADVERTISED_LISTENERS`**
>
> Vá à aba **"Settings"** do seu serviço Kafka. Na secção "Networking", copie a sua **URL Pública** e use-a para substituir `your-service-name.up.railway.app`.

### \#\#\# Passo 5: Configurar o Deploy Final

1.  Vá para a aba **"Settings" -\> "Build"**.
2.  Certifique-se que o "Build Method" está definido como **Dockerfile**.
3.  Vá para a aba **"Settings" -\> "Deploy"**.
4.  Certifique-se que os campos **"Start Command"** e **"User"** estão **VAZIOS**.
5.  O seu serviço irá fazer o deploy automaticamente. Verifique os logs para garantir que arranca sem erros.

-----

## 2\. Configurando o Kafka UI

Com o Kafka a funcionar, vamos adicionar uma interface web para o gerir.

### \#\#\# Passo 1: Criar um Novo Serviço para o Kafka UI

1.  No seu projeto Railway, clique em **"New" -\> "Service"**.
2.  Selecione a opção **"Deploy from Image"**.
3.  Use a seguinte imagem Docker: `provectus/kafka-ui:latest`.
4.  O Railway irá criar um novo serviço e expor uma porta pública para ele.

### \#\#\# Passo 2: Configurar as Variáveis de Ambiente do Kafka UI

Selecione o seu novo serviço Kafka UI e vá para a aba **"Variables"**. Adicione as seguintes variáveis para o conectar ao seu broker Kafka:

| Nome da Variável                      | Valor                                                                  |
| ------------------------------------- | ---------------------------------------------------------------------- |
| **`KAFKA_CLUSTERS_0_NAME`** | `Railway Kafka` (ou qualquer nome que preferir)                    |
| **`KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS`** | `your-service-name.up.railway.app:9092`                                |
| **`DYNAMIC_CONFIG_ENABLED`** | `true` (Permite alterar configurações pela UI) |

> **‼️ MUITO IMPORTANTE: `BOOTSTRAPSERVERS`**
>
> O valor para `KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS` é **exatamente a parte do host e porta** que você configurou em `KAFKA_ADVERTISED_LISTENERS` no seu serviço Kafka.

### \#\#\# Passo 3: Aceder à Interface

Após o deploy do serviço Kafka UI, aceda à sua URL pública. Deverá ver o seu cluster "Railway Kafka" e poderá começar a criar tópicos, enviar mensagens e gerir o seu broker.

-----

## Troubleshooting

  * **Erros sobre dados antigos (`Unable to read broker epoch`):** Se alguma vez precisar de recomeçar do zero, vá à aba **"Volumes"** do seu serviço Kafka, clique no menu do volume e selecione **"Clear Volume"**. Isto irá apagar todos os dados e permitir um arranque limpo.
  * **Erros de Conexão:** Verifique 100% que a URL e a porta em `KAFKA_ADVERTISED_LISTENERS` (no serviço Kafka) e `KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS` (no serviço Kafka UI) são idênticas.
