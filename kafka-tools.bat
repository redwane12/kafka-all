@echo off
echo ========================================
echo Ferramentas Apache Kafka
echo ========================================
echo.
echo Escolha uma opção:
echo 1. Criar tópico
echo 2. Listar tópicos
echo 3. Deletar tópico
echo 4. Enviar mensagem (Producer)
echo 5. Consumir mensagens (Consumer)
echo 6. Sair
echo.
set /p choice="Digite sua escolha (1-6): "

if "%choice%"=="1" goto create_topic
if "%choice%"=="2" goto list_topics
if "%choice%"=="3" goto delete_topic
if "%choice%"=="4" goto producer
if "%choice%"=="5" goto consumer
if "%choice%"=="6" goto end
goto invalid

:create_topic
set /p topic_name="Nome do tópico: "
set /p partitions="Número de partições (padrão 1): "
if "%partitions%"=="" set partitions=1
set /p replication="Fator de replicação (padrão 1): "
if "%replication%"=="" set replication=1

docker exec kafka kafka-topics --create --topic %topic_name% --bootstrap-server localhost:9092 --partitions %partitions% --replication-factor %replication%
echo Tópico '%topic_name%' criado com sucesso!
pause
goto end

:list_topics
echo Listando tópicos...
docker exec kafka kafka-topics --list --bootstrap-server localhost:9092
pause
goto end

:delete_topic
set /p topic_name="Nome do tópico para deletar: "
docker exec kafka kafka-topics --delete --topic %topic_name% --bootstrap-server localhost:9092
echo Tópico '%topic_name%' deletado!
pause
goto end

:producer
set /p topic_name="Nome do tópico: "
echo Digite suas mensagens (Ctrl+C para sair):
docker exec -it kafka kafka-console-producer --topic %topic_name% --bootstrap-server localhost:9092
goto end

:consumer
set /p topic_name="Nome do tópico: "
echo Consumindo mensagens do tópico '%topic_name%' (Ctrl+C para sair):
docker exec -it kafka kafka-console-consumer --topic %topic_name% --bootstrap-server localhost:9092 --from-beginning
goto end

:invalid
echo Opção inválida!
pause
goto end

:end
