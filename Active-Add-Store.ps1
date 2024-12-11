$EnableKMSActivation = $true
$EnableAddStore = $false

$WorkFolder = "C:\Temp\SetupFiles"
if (!(Test-Path $WorkFolder)) { New-Item -ItemType Directory -Path $WorkFolder }

if ($EnableAddStore) {
    Write-Host "Step 1: Installing Microsoft Store..."
    $RepoUrl = "https://codeload.github.com/kkkgo/LTSC-Add-MicrosoftStore/zip/refs/heads/master"
    $ZipFile = "$env:TEMP\LTSC-Add-MicrosoftStore.zip"
    $ExtractPath = "$env:TEMP\LTSC-Add-MicrosoftStore"

    Write-Host "Downloading repository from GitHub..."
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile($RepoUrl, $ZipFile)
    Write-Host "Repository downloaded to: $ZipFile"

    Write-Host "Extracting repository..."
    Expand-Archive -Path $ZipFile -DestinationPath $ExtractPath -Force
    Write-Host "Repository extracted to: $ExtractPath"

    $AddStoreScript = "$ExtractPath\LTSC-Add-MicrosoftStore-master\Add-Store.cmd"
    Write-Host "Executing Add-Store.cmd..."
    $CmdFile = "$ExtractPath\LTSC-Add-MicrosoftStore-master\Add-Store.cmd"
    (Get-Content $CmdFile) -notmatch 'pause' | Set-Content $CmdFile
    Write-Host "Removed 'pause' command from $CmdFile."
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c $AddStoreScript" -Wait
    Write-Host "Microsoft Store installation completed!"
}

# URL của tệp cần tải
$url = "https://github.com/mjishnu/alt-app-installer/releases/download/v2.6.9/alt.app.installer.exe"

# Đường dẫn lưu tệp
$outputPath = "C:\Users\Public\Downloads\alt.app.installer.exe"

# Tải tệp và thực thi
Invoke-WebRequest -Uri $url -OutFile $outputPath
Start-Process -FilePath $outputPath -Wait

Write-Host "Tệp đã được tải về và thực thi."


if ($EnableKMSActivation) {
    Write-Host "Step 2: Activating Windows license..."
    Write-Host "Press '3' in the cmd window to complete the activation process."
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -Command irm https://get.activated.win | iex"
    Write-Host "Windows activation completed!"
}



Write-Host "Installation process completed!"
