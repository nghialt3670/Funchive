param(
    [Parameter(Position=0)]
    [ValidateSet("start", "stop", "logs", "status", "build", "restart")]
    [string]$Action = "start"
)

$ComposeFiles = @("-f", "docker-compose.yml", "-f", "docker-compose.qa.yml")

Write-Host "Funchive QA Environment" -ForegroundColor Magenta
Write-Host "=======================" -ForegroundColor Magenta
Write-Host ""

switch ($Action) {
    "stop" {
        Write-Host "Stopping QA services..." -ForegroundColor Yellow
        docker-compose @ComposeFiles down
    }
    "logs" {
        Write-Host "Showing logs for QA services..." -ForegroundColor Cyan
        docker-compose @ComposeFiles logs -f
    }
    "status" {
        Write-Host "Checking status of QA services..." -ForegroundColor Cyan
        docker-compose @ComposeFiles ps
    }
    "build" {
        Write-Host "Building and starting QA services..." -ForegroundColor Yellow
        docker-compose @ComposeFiles up --build -d
    }
    "restart" {
        Write-Host "Restarting QA services..." -ForegroundColor Yellow
        docker-compose @ComposeFiles restart
    }
    default {
        Write-Host "Starting QA services..." -ForegroundColor Yellow
        docker-compose @ComposeFiles up -d
    }
}

if ($Action -ne "logs") {
    Write-Host ""
    Write-Host "Available commands:" -ForegroundColor Magenta
    Write-Host "  .\run-qa.ps1 start    - Start services (default)" -ForegroundColor White
    Write-Host "  .\run-qa.ps1 stop     - Stop services" -ForegroundColor White
    Write-Host "  .\run-qa.ps1 logs     - Show logs" -ForegroundColor White
    Write-Host "  .\run-qa.ps1 status   - Show status" -ForegroundColor White
    Write-Host "  .\run-qa.ps1 build    - Build and start services" -ForegroundColor White
    Write-Host "  .\run-qa.ps1 restart  - Restart services" -ForegroundColor White
    Write-Host ""
    Write-Host "QA services will be available at:" -ForegroundColor Magenta
    Write-Host "  - Gateway: http://localhost:8080" -ForegroundColor Cyan
    Write-Host "  - Web App: http://localhost:3000" -ForegroundColor Cyan
}