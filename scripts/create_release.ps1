$token = $env:GITHUB_TOKEN
if (-not $token) { Write-Error 'GITHUB_TOKEN not set'; exit 1 }
$owner='bestofexpertopera-bit'
$repo='yourapp-updates'
$tag='v3.10.5'
$name='v3.10.5'
$body='Release v3.10.5: version bump, fixed bundled app load'
$payload = @{ tag_name=$tag; name=$name; body=$body } | ConvertTo-Json -Depth 4
$headers = @{ Authorization = "token $token"; 'User-Agent'='release-script' }
Write-Output 'Creating release...'
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/$owner/$repo/releases" -Method Post -Headers $headers -Body $payload -ContentType 'application/json'
$uploadBase = $release.upload_url -replace '\{.*\}$',''
$assetPath = 'C:\Users\alass\OneDrive\Desktop\bestofshopv1\apk\app-release.apk'
$uploadUrl = "$uploadBase?name=$(Split-Path $assetPath -Leaf)"
Write-Output "Upload URL: $uploadUrl"
Write-Output 'Uploading asset...'
Invoke-RestMethod -Uri $uploadUrl -Method Post -Headers @{ Authorization = "token $token"; 'User-Agent'='release-script'; 'Content-Type'='application/vnd.android.package-archive' } -InFile $assetPath
Write-Output 'RELEASE_CREATED'
