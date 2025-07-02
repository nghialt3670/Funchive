@echo off
echo ===============================================
echo            DOCKER CONNECTIVITY TEST
echo ===============================================
echo.

REM Check if Docker is installed
echo [1/8] Checking if Docker is installed...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not installed or not in PATH
    goto :error
) else (
    echo ✅ Docker is installed
    docker --version
)
echo.

REM Check if Docker daemon is running
echo [2/8] Testing Docker daemon connectivity...
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker daemon is not running or not accessible
    echo Please start Docker Desktop
    goto :error
) else (
    echo ✅ Docker daemon is running
)
echo.

REM Check Docker version and info
echo [3/8] Getting Docker system information...
docker info | findstr "Server Version"
docker info | findstr "Storage Driver"
docker info | findstr "Operating System"
echo.

REM Test basic Docker operations
echo [4/8] Testing basic Docker operations...
docker ps >nul 2>&1
if errorlevel 1 (
    echo ❌ Cannot list containers
    goto :error
) else (
    echo ✅ Can list containers
    docker ps --format "table {{.Names}}\t{{.Status}}" | findstr /V "NAMES"
)
echo.

REM Test Docker image operations
echo [5/8] Testing Docker image operations...
docker images >nul 2>&1
if errorlevel 1 (
    echo ❌ Cannot list images
    goto :error
) else (
    echo ✅ Can list images
    for /f "tokens=1,2" %%a in ('docker images --format "{{.Repository}} {{.Tag}}" 2^>nul') do (
        echo   - %%a:%%b
    )
)
echo.

REM Test Docker volume mounting (common Windows issue)
echo [6/8] Testing Docker volume mounting...
docker run --rm -v "%cd%:/test" hello-world >nul 2>&1
if errorlevel 1 (
    echo ❌ Volume mounting failed - this is a common Windows issue
    echo Try the following:
    echo   1. Enable "Shared Drives" in Docker Desktop settings
    echo   2. Restart Docker Desktop
    echo   3. Check Windows firewall settings
) else (
    echo ✅ Volume mounting works
)
echo.

REM Test Docker named pipes (Windows specific)
echo [7/8] Testing Docker named pipes...
if exist "\\.\pipe\docker_engine" (
    echo ✅ docker_engine named pipe exists
) else (
    echo ❌ docker_engine named pipe not found
)

if exist "\\.\pipe\dockerDesktopLinuxEngine" (
    echo ✅ dockerDesktopLinuxEngine named pipe exists
) else (
    echo ❌ dockerDesktopLinuxEngine named pipe not found
)
echo.

REM Test application's Docker connectivity
echo [8/8] Testing application Docker connectivity...
echo Making HTTP request to test endpoint...
curl -s -o nul -w "HTTP Status: %%{http_code}" "http://localhost:8082/functions/test/docker" 2>nul
if errorlevel 1 (
    echo ❌ Cannot reach application Docker test endpoint
    echo Make sure your application is running on port 8082
) else (
    echo ✅ Application Docker test endpoint is reachable
)
echo.

echo ===============================================
echo            DOCKER TEST COMPLETED
echo ===============================================
echo.
echo If you see any ❌ errors above, please fix them before running the application.
echo.
echo Common solutions:
echo   1. Restart Docker Desktop
echo   2. Check Docker Desktop settings - ensure Linux containers are enabled
echo   3. Try different Docker host in application.yml:
echo      - npipe:////./pipe/docker_engine
echo      - npipe:////./pipe/dockerDesktopLinuxEngine
echo   4. Increase timeout values in application.yml
echo   5. Check Windows firewall settings
echo.
goto :end

:error
echo.
echo ===============================================
echo            DOCKER TEST FAILED
echo ===============================================
echo.
echo Please fix the Docker issues above before running the application.
echo.
echo Docker Desktop troubleshooting:
echo   1. Restart Docker Desktop
echo   2. Switch to Linux containers (if using Windows containers)
echo   3. Check Docker Desktop settings
echo   4. Restart Windows (if all else fails)
echo.

:end
pause 