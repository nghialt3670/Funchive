@echo off
echo Starting Funchive Development Environment...
echo.

if "%1"=="stop" (
    echo Stopping development services...
    docker-compose -f docker-compose.yml -f docker-compose.dev.yml down
    goto :end
)

if "%1"=="logs" (
    echo Showing logs for development services...
    docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs -f
    goto :end
)

if "%1"=="status" (
    echo Checking status of development services...
    docker-compose -f docker-compose.yml -f docker-compose.dev.yml ps
    goto :end
)

if "%1"=="build" (
    echo Building and starting development services...
    docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build -d
    goto :end
)

echo Starting development services...
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

:end
echo.
echo Available commands:
echo   run-dev.bat         - Start services
echo   run-dev.bat stop    - Stop services
echo   run-dev.bat logs    - Show logs
echo   run-dev.bat status  - Show status
echo   run-dev.bat build   - Build and start services
echo.
echo Development services will be available at:
echo   - Config Server: http://localhost:8888
echo   - Discovery Server: http://localhost:8761
echo   - User Service: http://localhost:8081
echo   - Function Service: http://localhost:8082
echo   - Gateway: http://localhost:8080
echo   - Web App: http://localhost:3000 