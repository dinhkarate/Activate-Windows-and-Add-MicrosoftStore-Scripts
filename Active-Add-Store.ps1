$EnableKMSActivation = $true
$EnableAddStore = $true

$WorkFolder = "C:\Temp\SetupFiles"
if (!(Test-Path $WorkFolder)) { New-Item -ItemType Directory -Path $WorkFolder }

if ($EnableAddStore) {
    Write-Host "Step 1: Cài đặt Microsoft Store..."
    $RepoUrl = "https://codeload.github.com/kkkgo/LTSC-Add-MicrosoftStore/zip/refs/heads/master"
    $ZipFile = "$env:TEMP\LTSC-Add-MicrosoftStore.zip"
    $ExtractPath = "$env:TEMP\LTSC-Add-MicrosoftStore"

    Write-Host "Đang tải repo từ GitHub..."
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile($RepoUrl, $ZipFile)
    Write-Host "Đã tải repo về: $ZipFile"

    Write-Host "Đang giải nén repo..."
    Expand-Archive -Path $ZipFile -DestinationPath $ExtractPath -Force
    Write-Host "Đã giải nén vào: $ExtractPath"

    $AddStoreScript = "$ExtractPath\LTSC-Add-MicrosoftStore-master\Add-Store.cmd"
    Write-Host "Đang thực thi Add-Store.cmd..."
    $CmdFile = "$ExtractPath\LTSC-Add-MicrosoftStore-master\Add-Store.cmd"
    (Get-Content $CmdFile) -notmatch 'pause' | Set-Content $CmdFile
    Write-Host "Đã loại bỏ lệnh 'pause' khỏi $CmdFile."
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c $AddStoreScript" -Wait
    Write-Host "Đã hoàn tất cài đặt Microsoft Store!"

}

if ($EnableKMSActivation) {
    Write-Host "Step 2: Kích hoạt bản quyền Windows..."
    Write-Host "Ấn phím 3 sau khi cmd chạy lên để hoàn tất kích hoạt"
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -Command irm https://get.activated.win | iex"
    Write-Host "Đã kích hoạt bản quyền Windows!"
}

Write-Host "Hoàn tất quá trình cài đặt!"
