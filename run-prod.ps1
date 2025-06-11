param(
    [Parameter(Position=0)]
    [ValidateSet("start", "stop", "logs", "status", "build", "restart")]
    [string]$Action = "start"
)

$ComposeFiles = @("-f", "docker-compose.yml", "-f", "docker-compose.prod.yml")

Write-Host "Funchive Production Environment" -ForegroundColor Red
Write-Host "===============================" -ForegroundColor Red
Write-Host ""

switch ($Action) {
    "stop" {
        Write-Host "Stopping production services..." -ForegroundColor Yellow
        docker-compose @ComposeFiles down
    }
    "logs" {
        Write-Host "Showing logs for production services..." -ForegroundColor Cyan
        docker-compose @ComposeFiles logs -f
    }
    "status" {
        Write-Host "Checking status of production services..." -ForegroundColor Cyan
        docker-compose @ComposeFiles ps
    }
    "build" {
        Write-Host "Building and starting production services..." -ForegroundColor Yellow
        docker-compose @ComposeFiles up --build -d
    }
    "restart" {
        Write-Host "Restarting production services..." -ForegroundColor Yellow
        docker-compose @ComposeFiles restart
    }
    default {
        Write-Host "Starting production services..." -ForegroundColor Yellow
        docker-compose @ComposeFiles up -d
    }
}

if ($Action -ne "logs") {
    Write-Host ""
    Write-Host "Available commands:" -ForegroundColor Red
    Write-Host "  .\run-prod.ps1 start    - Start services (default)" -ForegroundColor White
    Write-Host "  .\run-prod.ps1 stop     - Stop services" -ForegroundColor White
    Write-Host "  .\run-prod.ps1 logs     - Show logs" -ForegroundColor White
    Write-Host "  .\run-prod.ps1 status   - Show status" -ForegroundColor White
    Write-Host "  .\run-prod.ps1 build    - Build and start services" -ForegroundColor White
    Write-Host "  .\run-prod.ps1 restart  - Restart services" -ForegroundColor White
    Write-Host ""
    Write-Host "Production services will be available at:" -ForegroundColor Red
    Write-Host "  - Gateway: http://localhost:8080" -ForegroundColor Cyan
    Write-Host "  - Web App: http://localhost:3000" -ForegroundColor Cyan
}