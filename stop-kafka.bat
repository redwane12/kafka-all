@echo off
echo Parando Apache Kafka...
echo.

docker-compose down

echo.
echo ========================================
echo Kafka foi parado!
echo.
echo Para iniciar novamente, execute: start-kafka.bat
echo ========================================
echo.
pause
