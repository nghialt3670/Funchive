@echo off
echo ===============================================
echo         PRE-PULLING DOCKER IMAGES
echo ===============================================
echo.
echo This will pre-pull common Docker images used for function compilation
echo to avoid timeout issues during function execution.
echo.

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running. Please start Docker Desktop first.
    goto :error
)

echo [1/6] Pre-pulling Python images...
echo Pulling python:3.9-slim (this may take several minutes)...
docker pull python:3.9-slim
if errorlevel 1 (
    echo ❌ Failed to pull python:3.9-slim
) else (
    echo ✅ Successfully pulled python:3.9-slim
)
echo.

echo Pulling python:3.11-slim...
docker pull python:3.11-slim
if errorlevel 1 (
    echo ❌ Failed to pull python:3.11-slim
) else (
    echo ✅ Successfully pulled python:3.11-slim
)
echo.

echo [2/6] Pre-pulling Java images...
echo Pulling openjdk:11-jdk-slim...
docker pull openjdk:11-jdk-slim
if errorlevel 1 (
    echo ❌ Failed to pull openjdk:11-jdk-slim
) else (
    echo ✅ Successfully pulled openjdk:11-jdk-slim
)
echo.

echo Pulling openjdk:17-jdk-slim...
docker pull openjdk:17-jdk-slim
if errorlevel 1 (
    echo ❌ Failed to pull openjdk:17-jdk-slim
) else (
    echo ✅ Successfully pulled openjdk:17-jdk-slim
)
echo.

echo [3/6] Pre-pulling Node.js images...
echo Pulling node:18-alpine...
docker pull node:18-alpine
if errorlevel 1 (
    echo ❌ Failed to pull node:18-alpine
) else (
    echo ✅ Successfully pulled node:18-alpine
)
echo.

echo Pulling node:20-alpine...
docker pull node:20-alpine
if errorlevel 1 (
    echo ❌ Failed to pull node:20-alpine
) else (
    echo ✅ Successfully pulled node:20-alpine
)
echo.

echo [4/6] Pre-pulling C++ images...
echo Pulling gcc:latest...
docker pull gcc:latest
if errorlevel 1 (
    echo ❌ Failed to pull gcc:latest
) else (
    echo ✅ Successfully pulled gcc:latest
)
echo.

echo [5/6] Pre-pulling utility images...
echo Pulling alpine:latest...
docker pull alpine:latest
if errorlevel 1 (
    echo ❌ Failed to pull alpine:latest
) else (
    echo ✅ Successfully pulled alpine:latest
)
echo.

echo Pulling ubuntu:22.04...
docker pull ubuntu:22.04
if errorlevel 1 (
    echo ❌ Failed to pull ubuntu:22.04
) else (
    echo ✅ Successfully pulled ubuntu:22.04
)
echo.

echo [6/6] Showing pulled images...
echo.
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}"
echo.

echo ===============================================
echo         IMAGE PRE-PULLING COMPLETED
echo ===============================================
echo.
echo ✅ Docker images have been pre-pulled successfully!
echo.
echo This should significantly reduce compilation times and avoid timeout issues.
echo You can now run your function service without image pulling delays.
echo.
goto :end

:error
echo.
echo Please start Docker Desktop and try again.
echo.

:end
pause 