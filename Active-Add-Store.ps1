$EnableKMSActivation = $true
$EnableAddStore = $true

$WorkFolder = "C:\Temp\SetupFiles"
if (!(Test-Path $WorkFolder)) { New-Item -ItemType Directory -Path $WorkFolder }

if ($EnableKMSActivation) {
    Write-Host "Step 1: Kích hoạt bản quyền Windows..."
    irm https://get.activated.win | iex
    Write-Host "Đã kích hoạt bản quyền Windows!"
}

if ($EnableAddStore) {
    Write-Host "Step 2: Cài đặt Microsoft Store..."
    $RepoUrl = "https://github.com/kkkgo/LTSC-Add-MicrosoftStore/archive/refs/heads/master.zip"
    $ZipFile = "$WorkFolder\LTSC-Add-MicrosoftStore.zip"
    $ExtractPath = "$WorkFolder\LTSC-Add-MicrosoftStore"

    Write-Host "Đang tải repo từ GitHub..."
    Invoke-WebRequest -Uri $RepoUrl -OutFile $ZipFile -UseBasicParsing
    Write-Host "Đã tải repo về: $ZipFile"

    Write-Host "Đang giải nén repo..."
    Expand-Archive -Path $ZipFile -DestinationPath $ExtractPath -Force
    Write-Host "Đã giải nén vào: $ExtractPath"

    $AddStoreScript = "$ExtractPath\LTSC-Add-MicrosoftStore-master\Add-Store.cmd"
    Write-Host "Đang thực thi Add-Store.cmd..."
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c $AddStoreScript" -Wait
    Write-Host "Đã cài đặt Microsoft Store!"
}

Write-Host "Hoàn tất quá trình cài đặt!"
