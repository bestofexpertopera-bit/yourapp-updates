# Cheat Store OTA Güncelleme Script'i
# Bu script her çalıştırıldığında:
# 1. Versiyon numarasını otomatik artırır
# 2. Değişiklikleri GitHub'a gönderir
# 3. Eski commit'leri siler (sadece son sürüm kalır)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cheat Store OTA Güncelleme Yayınlayıcı" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Klasör yolları
$repoPath = "$PSScriptRoot\github-updates"

# Mevcut versiyonu oku
$appHtml = Get-Content "$repoPath\app.html" -Raw
$versionMatch = [regex]::Match($appHtml, "APP_VERSION\s*=\s*'([^']+)'")
if ($versionMatch.Success) {
    $currentVersion = $versionMatch.Groups[1].Value
    Write-Host "Mevcut Versiyon: v$currentVersion" -ForegroundColor Yellow
} else {
    Write-Host "Versiyon bulunamadi!" -ForegroundColor Red
    exit 1
}

# Versiyon artır
$versionParts = $currentVersion.Split('.')
$major = [int]$versionParts[0]
$minor = [int]$versionParts[1]
$patch = [int]$versionParts[2]
$patch++
$newVersion = "$major.$minor.$patch"

Write-Host "Yeni Versiyon: v$newVersion" -ForegroundColor Green
Write-Host ""

# Değişiklik notu al
$changeNote = Read-Host "Değişiklik notu girin (boş bırakırsanız 'Güncelleme' yazılır)"
if ([string]::IsNullOrWhiteSpace($changeNote)) {
    $changeNote = "Güncelleme"
}

# app.html'de versiyonu güncelle
$appHtml = $appHtml -replace "APP_VERSION\s*=\s*'[^']+'", "APP_VERSION = '$newVersion'"
Set-Content -Path "$repoPath\app.html" -Value $appHtml -Encoding UTF8

# manifest.json'u güncelle
$manifest = Get-Content "$repoPath\manifest.json" -Raw | ConvertFrom-Json
$manifest.version = $newVersion
$manifest.buildNumber++
$manifest.minBuildNumber = $manifest.buildNumber
$manifest.releaseDate = (Get-Date).ToString("yyyy-MM-dd")
$manifest.changelog = @($changeNote)
$manifest.required = $false
$manifest | ConvertTo-Json -Depth 10 | Set-Content -Path "$repoPath\manifest.json" -Encoding UTF8

Write-Host ""
Write-Host "Değişiklikler hazırlandı." -ForegroundColor Green
Write-Host ""

# Git işlemleri
Set-Location $repoPath

# Eski commit'leri silmek istiyor mu?
$cleanHistory = Read-Host "Eski commit'leri silmek istiyor musunuz? (E/H)"

if ($cleanHistory -eq "E" -or $cleanHistory -eq "e") {
    Write-Host "Eski commit'ler temizleniyor..." -ForegroundColor Yellow
    
    # Orphan branch ile temiz başlangıç
    git checkout --orphan temp_clean_branch
    git add -A
    git commit -m "v$newVersion - $changeNote"
    git branch -D main 2>$null
    git branch -m main
    git push -f origin main
    git push --set-upstream origin main 2>$null
    
    Write-Host "Tüm eski commit'ler silindi!" -ForegroundColor Green
} else {
    # Normal commit
    git add -A
    git commit -m "v$newVersion - $changeNote"
    git push
    
    Write-Host "Değişiklikler gönderildi." -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  v$newVersion başarıyla yayınlandı!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Uygulama 30 saniye içinde otomatik güncellenecek." -ForegroundColor Yellow
Write-Host ""
Read-Host "Çıkmak için Enter'a basın"
