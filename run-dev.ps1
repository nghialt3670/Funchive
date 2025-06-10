param(
    [Parameter(Position=0)]
    [ValidateSet("start", "stop", "logs", "status", "build", "restart")]
    [string]$Action = "start"
)

$ComposeFiles = @("-f", "docker-compose.yml", "-f", "docker-compose.dev.yml")

Write-Host "Funchive Development Environment" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

switch ($Action) {
    "stop" {
        Write-Host "Stopping development services..." -ForegroundColor Yellow
        docker-compose @ComposeFiles down
    }
    "logs" {
        Write-Host "Showing logs for development services..." -ForegroundColor Cyan
        docker-compose @ComposeFiles logs -f
    }
    "status" {
        Write-Host "Checking status of development services..." -ForegroundColor Cyan
        docker-compose @ComposeFiles ps
    }
    "build" {
        Write-Host "Building and starting development services..." -ForegroundColor Yellow
        docker-compose @ComposeFiles up --build -d
    }
    "restart" {
        Write-Host "Restarting development services..." -ForegroundColor Yellow
        docker-compose @ComposeFiles restart
    }
    default {
        Write-Host "Starting development services..." -ForegroundColor Yellow
        docker-compose @ComposeFiles up -d
    }
}

if ($Action -ne "logs") {
    Write-Host ""
    Write-Host "Available commands:" -ForegroundColor Green
    Write-Host "  .\run-dev.ps1 start    - Start services (default)" -ForegroundColor White
    Write-Host "  .\run-dev.ps1 stop     - Stop services" -ForegroundColor White
    Write-Host "  .\run-dev.ps1 logs     - Show logs" -ForegroundColor White
    Write-Host "  .\run-dev.ps1 status   - Show status" -ForegroundColor White
    Write-Host "  .\run-dev.ps1 build    - Build and start services" -ForegroundColor White
    Write-Host "  .\run-dev.ps1 restart  - Restart services" -ForegroundColor White
    Write-Host ""
    Write-Host "Development services will be available at:" -ForegroundColor Green
    Write-Host "  - Config Server: http://localhost:8888" -ForegroundColor Cyan
    Write-Host "  - Discovery Server: http://localhost:8761" -ForegroundColor Cyan
    Write-Host "  - User Service: http://localhost:8081" -ForegroundColor Cyan
    Write-Host "  - Function Service: http://localhost:8082" -ForegroundColor Cyan
    Write-Host "  - Gateway: http://localhost:8080" -ForegroundColor Cyan
    Write-Host "  - Web App: http://localhost:3000" -ForegroundColor Cyan
} 