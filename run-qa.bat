@echo off
echo Starting Funchive QA Environment...
echo.

if "%1"=="stop" (
    echo Stopping QA services...
    docker-compose -f docker-compose.yml -f docker-compose.qa.yml down
    goto :end
)

if "%1"=="logs" (
    echo Showing logs for QA services...
    docker-compose -f docker-compose.yml -f docker-compose.qa.yml logs -f
    goto :end
)

if "%1"=="status" (
    echo Checking status of QA services...
    docker-compose -f docker-compose.yml -f docker-compose.qa.yml ps
    goto :end
)

if "%1"=="build" (
    echo Building and starting QA services...
    docker-compose -f docker-compose.yml -f docker-compose.qa.yml up --build -d
    goto :end
)

echo Starting QA services...
docker-compose -f docker-compose.yml -f docker-compose.qa.yml up -d

:end
echo.
echo Available commands:
echo   run-qa.bat         - Start services
echo   run-qa.bat stop    - Stop services
echo   run-qa.bat logs    - Show logs
echo   run-qa.bat status  - Show status
echo   run-qa.bat build   - Build and start services
echo.
echo QA services will be available at:
echo   - Gateway: http://localhost:8080
echo   - Web App: http://localhost:3000 