# Hızlı Key Değiştirme Script'i
# Sadece key değiştirmek için bu script'i kullanın

param(
    [Parameter(Mandatory=$true)]
    [string]$YeniKey
)

$updateDir = "c:\Users\onurt\Desktop\Mobil Uygulama\github-updates"
$configPath = Join-Path $updateDir "config.json"
$manifestPath = Join-Path $updateDir "manifest.json"

# Config'i güncelle
$config = Get-Content $configPath | ConvertFrom-Json
$eskiKey = $config.key
$config.key = $YeniKey
$config | ConvertTo-Json | Set-Content $configPath -Encoding UTF8

# Build number artır
$manifest = Get-Content $manifestPath | ConvertFrom-Json
$manifest.buildNumber = $manifest.buildNumber + 1
$manifest.changelog = @("Key güncellendi")
$manifest | ConvertTo-Json | Set-Content $manifestPath -Encoding UTF8

# GitHub'a push
Push-Location $updateDir
git add .
git commit -m "Key updated: $eskiKey -> $YeniKey"
git push origin main
Pop-Location

Write-Host ""
Write-Host "✅ KEY DEĞİŞTİRİLDİ!" -ForegroundColor Green
Write-Host "Eski: $eskiKey" -ForegroundColor Yellow
Write-Host "Yeni: $YeniKey" -ForegroundColor Green
Write-Host ""
Write-Host "Tüm kullanıcılar ~5 dakika içinde yeni key'i alacak!" -ForegroundColor Cyan
