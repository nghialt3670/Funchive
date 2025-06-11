@echo off
setlocal enabledelayedexpansion

set BASE_URL=https://github.com/nghialt3670

set SERVICES=funchive-config-server funchive-discovery-server funchive-function-service funchive-gateway-server funchive-user-service funchive-web funchive-config-repo

for %%S in (%SERVICES%) do (
    if not exist "%%S" (
        echo Cloning %%S...
        git clone %BASE_URL%/%%S.git
    ) else (
        echo %%S already exists. Skipping...
    )
)

echo.
echo All services checked.
pause
