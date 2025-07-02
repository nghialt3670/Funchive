@echo off
echo Starting Funchive with Docker in Docker...
echo.

if "%1"=="stop" (
    echo Stopping Docker in Docker services...
    docker-compose down
    goto :end
)

if "%1"=="logs" (
    echo Showing Docker in Docker logs...
    docker-compose logs -f docker-dind
    goto :end
)

if "%1"=="test" (
    echo Running Docker in Docker test...
    call test-docker-dind.bat
    goto :end
)

if "%1"=="clean" (
    echo Cleaning Docker in Docker volumes...
    docker-compose down -v
    docker volume prune -f
    goto :end
)

echo [1/3] Starting Docker in Docker daemon...
docker-compose up -d docker-dind

echo [2/3] Waiting for Docker in Docker to be ready...
timeout /t 15 /nobreak >nul

echo Testing DinD connectivity...
for /l %%i in (1,1,6) do (
    docker exec funchive-docker-dind docker info >nul 2>&1
    if not errorlevel 1 (
        echo ✅ Docker in Docker is ready!
        goto :dind_ready
    )
    echo Waiting... (attempt %%i/6)
    timeout /t 5 /nobreak >nul
)
echo ❌ Docker in Docker failed to start
echo Try: run-dind.bat test
goto :error

:dind_ready
echo.
echo [3/3] Starting application services...
docker-compose up -d

echo.
echo ===============================================
echo     FUNCHIVE WITH DOCKER IN DOCKER STARTED
echo ===============================================
echo.
echo Services are starting up...
echo.
echo Available services:
echo   - Config Server: http://localhost:8888
echo   - Discovery Server: http://localhost:8761  
echo   - User Service: http://localhost:8081
echo   - Function Service: http://localhost:8082
echo   - Gateway: http://localhost:8080
echo   - Web App: http://localhost:3000
echo   - Docker Daemon: tcp://localhost:2375
echo.
echo Useful commands:
echo   run-dind.bat         - Start services
echo   run-dind.bat stop    - Stop services
echo   run-dind.bat logs    - Show Docker logs
echo   run-dind.bat test    - Test Docker setup
echo   run-dind.bat clean   - Clean volumes
echo.
echo To test Docker connectivity:
echo   curl http://localhost:8082/functions/test/docker
echo.
goto :end

:error
echo.
echo Failed to start Docker in Docker.
echo Try running: run-dind.bat test
echo.

:end 