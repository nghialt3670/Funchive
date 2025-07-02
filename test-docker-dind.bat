@echo off
echo ===============================================
echo        DOCKER IN DOCKER (DinD) TEST
echo ===============================================
echo.

echo [1/6] Checking if Docker Desktop is running...
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Desktop is not running
    echo Please start Docker Desktop before proceeding
    goto :error
) else (
    echo ✅ Docker Desktop is running
)
echo.

echo [2/6] Starting Docker in Docker service...
echo This will start the DinD container and wait for it to be ready...
docker-compose up -d docker-dind
if errorlevel 1 (
    echo ❌ Failed to start Docker in Docker service
    goto :error
)
echo ✅ Docker in Docker service started
echo.

echo [3/6] Waiting for Docker in Docker to be ready...
echo This may take 30-60 seconds...
timeout /t 10 /nobreak >nul
for /l %%i in (1,1,12) do (
    echo Testing DinD connectivity attempt %%i/12...
    docker exec funchive-docker-dind docker info >nul 2>&1
    if not errorlevel 1 (
        echo ✅ Docker in Docker is ready!
        goto :dind_ready
    )
    timeout /t 5 /nobreak >nul
)
echo ❌ Docker in Docker failed to start properly
goto :error

:dind_ready
echo.

echo [4/6] Testing Docker in Docker functionality...
echo Running hello-world in DinD...
docker exec funchive-docker-dind docker run --rm hello-world >nul 2>&1
if errorlevel 1 (
    echo ❌ Failed to run container in Docker in Docker
    goto :error
) else (
    echo ✅ Successfully ran container in Docker in Docker
)
echo.

echo [5/6] Testing TCP connectivity to DinD...
echo Testing connection to localhost:2375...
powershell -Command "try { $response = Invoke-WebRequest -Uri http://localhost:2375/version -Method GET -TimeoutSec 10; Write-Host '✅ DinD TCP endpoint is accessible' } catch { Write-Host '❌ Cannot reach DinD TCP endpoint' }"
echo.

echo [6/6] Testing application Docker test endpoint...
echo Starting function service to test Docker connectivity...
docker-compose up -d funchive-function-service
echo Waiting for function service to start...
timeout /t 30 /nobreak >nul

echo Testing Docker connectivity via application API...
curl -s -o nul -w "HTTP Status: %%{http_code}" "http://localhost:8082/functions/test/docker" 2>nul
if errorlevel 1 (
    echo ❌ Cannot reach application Docker test endpoint
    echo Make sure the function service is running properly
) else (
    echo ✅ Application Docker test endpoint is reachable
)
echo.

echo ===============================================
echo        DOCKER IN DOCKER TEST COMPLETED
echo ===============================================
echo.
echo ✅ Docker in Docker setup is working!
echo.
echo You can now:
echo 1. Use 'docker-compose up -d' to start all services with DinD
echo 2. Access Docker daemon at: tcp://localhost:2375
echo 3. Function service will use DinD for all Docker operations
echo.
echo To view logs: docker-compose logs -f docker-dind
echo To shell into DinD: docker exec -it funchive-docker-dind sh
echo.
goto :end

:error
echo.
echo ===============================================
echo        DOCKER IN DOCKER TEST FAILED
echo ===============================================
echo.
echo Troubleshooting steps:
echo 1. Ensure Docker Desktop is running
echo 2. Try: docker-compose down -v
echo 3. Try: docker-compose up --build -d docker-dind
echo 4. Check logs: docker-compose logs docker-dind
echo 5. Restart Docker Desktop if needed
echo.

:end
pause 