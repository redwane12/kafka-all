@echo off
echo Iniciando Apache Kafka...
echo.
echo Verificando se Docker está rodando...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERRO: Docker não está instalado ou não está rodando
    echo Instale o Docker Desktop primeiro
    pause
    exit /b 1
)

echo Iniciando containers Kafka e Zookeeper...
docker-compose up -d

echo.
echo Aguardando os serviços iniciarem...
timeout /t 10 /nobreak >nul

echo.
echo ========================================
echo Kafka está rodando!
echo.
echo Serviços disponíveis:
echo - Kafka Broker: localhost:9092
echo - Zookeeper: localhost:2181
echo - Kafka UI: http://localhost:8080
echo.
echo Para parar os serviços, execute: stop-kafka.bat
echo ========================================
echo.
pause
