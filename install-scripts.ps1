try {
    $ffmpegCommand = Get-Command ffmpeg -ErrorAction Stop
    Write-Host "FFmpeg is already installed. Checking for updates..." -ForegroundColor Yellow
    choco upgrade ffmpeg
} catch {
    Write-Host "FFmpeg is not installed. Installing..." -ForegroundColor Yellow
    choco install ffmpeg
}

# Check if yt-dlp is installed
try {
    $ytDlpCommand = Get-Command yt-dlp -ErrorAction Stop
    Write-Host "YT-DLP is already installed. Checking for updates..." -ForegroundColor Yellow
    choco upgrade yt-dlp
} catch {
    Write-Host "YT-DLP is not installed. Installing..." -ForegroundColor Yellow
    choco install yt-dlp

    Write-Host "Downloading YT-DLP-GUI (GUI for YT-DLP)" -ForegroundColor Yellow
        # Set download URL and destination folder
        $downloadUrl = "https://github.com/kannagi0303/yt-dlp-gui/releases/latest/download/yt-dlp-gui.exe"
        $destFolder = "C:\ProgramData\chocolatey\lib\yt-dlp\tools\x64"
        $ytDlpPath = Join-Path $destFolder "yt-dlp-gui.exe"

        # Create the destination folder if it doesn't exist
        if (!(Test-Path $destFolder)) {
            New-Item -ItemType Directory -Force -Path $destFolder
        }

        # Download the yt-dlp-gui.exe file
        Invoke-WebRequest -Uri $downloadUrl -OutFile $ytDlpPath

        # Check if the destination folder is in the PATH
        $envPath = [Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
        Write-Host "System/Machine Path before (Save this if PATH is cleared for some reason): $envPath"
        $paths = $envPath.Split(";")
        if ($paths -notcontains $destFolder) {
            Write-Host "`nAdding new folder to PATH"
            # Add the destination folder to the PATH
            $envPath += ";$destFolder"
            [Environment]::SetEnvironmentVariable("Path", $envPath, [System.EnvironmentVariableTarget]::Machine)
        }   
}

# Check if aria2c is installed
try {
    $ariaCommand = Get-Command aria2c -ErrorAction Stop
    Write-Host "aria2c is already installed. Checking for updates..." -ForegroundColor Yellow
    choco upgrade aria2
} catch {
    Write-Host "aria2c is not installed. Installing..." -ForegroundColor Yellow
    choco install aria2
}

# Check if scrcpy is installed
try {
    $ariaCommand = Get-Command scrcpy -ErrorAction Stop
    Write-Host "scrcpy is already installed. Checking for updates..." -ForegroundColor Yellow
    choco upgrade scrcpy
} catch {
    Write-Host "scrcpy is not installed. Installing..." -ForegroundColor Yellow
    choco install scrcpy
}

#---------------------------------------------------------------------------------

Write-Host "Downloading Ian's YT-DLP Scripts" -ForegroundColor Yellow

# Ask for user input for script directory
$scriptDirectory = Read-Host "Enter the script directory (e.g., D:\Downloads\Test)"

# Set download URL and destination folder
$downloadUrl = "https://github.com/LarawanIan/LarawanIan.github.io/raw/main/assets/archives/yt-dlp_scripts.zip"
$destFolder = "$scriptDirectory\yt-dlp"
$scriptsZipPath = Join-Path $destFolder "yt-dlp_scripts.zip"

# Create the destination folder if it doesn't exist
if (!(Test-Path $destFolder)) {
    New-Item -ItemType Directory -Force -Path $destFolder
} else {
    Get-ChildItem $destFolder | Where-Object { $_.FullName -ne (Join-Path $destFolder "Downloads") } | Remove-Item -Recurse -Force
}

# Download the yt-dlp scripts zip file
Invoke-WebRequest -Uri $downloadUrl -OutFile $scriptsZipPath

# Load assembly for ZipFile
Add-Type -AssemblyName System.IO.Compression.FileSystem

# Extract all files from the zip file
[System.IO.Compression.ZipFile]::ExtractToDirectory($scriptsZipPath, $destFolder)

# Remove the downloaded zip file
Remove-Item -Path $scriptsZipPath -Force

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$scriptDirectory\yt-dlp\YT-DLP.lnk")
$Shortcut.TargetPath = "C:\ProgramData\chocolatey\lib\yt-dlp\tools\x64\yt-dlp-gui.exe"
$Shortcut.Save()

$downloadsDirectory = Join-Path -Path $scriptDirectory -ChildPath "yt-dlp\Downloads"
New-Item -ItemType Directory -Path $downloadsDirectory

Write-Host "Downloading Ian's Simplified Scripts" -ForegroundColor Yellow

# Set download URL and destination folder
$downloadUrl = "https://github.com/LarawanIan/LarawanIan.github.io/raw/main/assets/archives/simplified_scripts.zip"
$destFolder = "$scriptDirectory\SimplifiedScripts"
$scriptsZipPath = Join-Path $destFolder "simplified_scripts.zip"

# Create the destination folder if it doesn't exist
if (!(Test-Path $destFolder)) {
    New-Item -ItemType Directory -Force -Path $destFolder
} else {
    Get-ChildItem $destFolder | Where-Object { $_.FullName -ne (Join-Path $destFolder "Downloads") } | Remove-Item -Recurse -Force
}

# Download the yt-dlp scripts zip file
Invoke-WebRequest -Uri $downloadUrl -OutFile $scriptsZipPath

# Load assembly for ZipFile
Add-Type -AssemblyName System.IO.Compression.FileSystem

# Extract all files from the zip file
[System.IO.Compression.ZipFile]::ExtractToDirectory($scriptsZipPath, $destFolder)

# Remove the downloaded zip file
Remove-Item -Path $scriptsZipPath -Force

# Done!
Write-Host "`n`nYT-DLP Scripts downloaded! You can now close this window if it stays open." -ForegroundColor Green
Write-Host "Should anything go wrong, your System/Machine PATH is displayed above."
Write-Host "Closing in 2 seconds"
Start-Sleep -Seconds 2