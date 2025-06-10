@echo off
echo Starting Funchive Production Environment...
echo.

if "%1"=="stop" (
    echo Stopping production services...
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml down
    goto :end
)

if "%1"=="logs" (
    echo Showing logs for production services...
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml logs -f
    goto :end
)

if "%1"=="status" (
    echo Checking status of production services...
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml ps
    goto :end
)

if "%1"=="build" (
    echo Building and starting production services...
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d
    goto :end
)

echo Starting production services...
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

:end
echo.
echo Available commands:
echo   run-prod.bat         - Start services
echo   run-prod.bat stop    - Stop services
echo   run-prod.bat logs    - Show logs
echo   run-prod.bat status  - Show status
echo   run-prod.bat build   - Build and start services
echo.
echo Production services will be available at:
echo   - Gateway: http://localhost:8080
echo   - Web App: http://localhost:3000 