# PowerShell script to test the Weather API

param(
    [Parameter(Mandatory=$true)]
    [string]$ApiUrl
)

Write-Host "Testing Weather API at: $ApiUrl" -ForegroundColor Green

# Test health endpoint
Write-Host "`nTesting health endpoint..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-RestMethod -Uri "$ApiUrl/api/weather/health" -Method Get
    Write-Host "Health Check: " -NoNewline
    Write-Host "SUCCESS" -ForegroundColor Green
    Write-Host "Response: $($healthResponse | ConvertTo-Json -Depth 2)"
} catch {
    Write-Host "Health Check: " -NoNewline
    Write-Host "FAILED" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)"
}

# Test weather endpoint
Write-Host "`nTesting weather endpoint..." -ForegroundColor Yellow
try {
    $weatherResponse = Invoke-RestMethod -Uri "$ApiUrl/api/weather" -Method Get
    Write-Host "Weather API: " -NoNewline
    Write-Host "SUCCESS" -ForegroundColor Green
    Write-Host "Response: $($weatherResponse | ConvertTo-Json -Depth 2)"
} catch {
    Write-Host "Weather API: " -NoNewline
    Write-Host "FAILED" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)"
}

Write-Host "`nAPI testing completed!" -ForegroundColor Green