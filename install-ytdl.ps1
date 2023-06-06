# Licensed under the GNU General Public License v3.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.gnu.org/licenses/gpl-3.0.en.html
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#    
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#    
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# ----------------------------------------
# This script downloads and places yt-dlp, ffmpeg, aria2c, scrcpy in C:\Tools, and adds it to PATH assuming it's not already there.
# ----------------------------------------

Invoke-Expression (Invoke-RestMethod Import-RemoteFunction.tc.ht) # Get RemoteFunction importer
Import-RemoteFunction -ScriptUri "Invoke-Elevated.tc.ht" # Import function to raise code to Admin
 
function Install-FFmpeg() {
    Invoke-Elevated {
        Write-Host "Downloading FFMPEG (A complete, cross-platform solution to record, convert and stream audio and video.)" -ForegroundColor Yellow
        # Set download URL and destination folder
        $downloadUrl = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
        $destFolder = "C:\Tools"
        $ffmpegPath = Join-Path $destFolder "ffmpeg-master-latest-win64-gpl.zip"
    
        # Create the destination folder if it doesn't exist
        if (!(Test-Path $destFolder)) {
            New-Item -ItemType Directory -Force -Path $destFolder
        }
    
        # Download the ffmpeg zip file
        Invoke-WebRequest -Uri $downloadUrl -OutFile $ffmpegPath
    
        # Load assembly for ZipFile
        Add-Type -AssemblyName System.IO.Compression.FileSystem
    
        # Extract only ffmpeg.exe from the zip file
        $zip = [System.IO.Compression.ZipFile]::OpenRead($ffmpegPath)
        $ffmpegExe = $zip.Entries | Where-Object { $_.FullName.EndsWith("ffmpeg.exe") }
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($ffmpegExe, (Join-Path $destFolder "ffmpeg.exe"), $true)
        $zip.Dispose()

        # Extract only ffplay.exe from the zip file
        $zip = [System.IO.Compression.ZipFile]::OpenRead($ffmpegPath)
        $ffplayExe = $zip.Entries | Where-Object { $_.FullName.EndsWith("ffplay.exe") }
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($ffplayExe, (Join-Path $destFolder "ffplay.exe"), $true)
        $zip.Dispose()

        # Extract only ffprobe.exe from the zip file
        $zip = [System.IO.Compression.ZipFile]::OpenRead($ffmpegPath)
        $ffplayExe = $zip.Entries | Where-Object { $_.FullName.EndsWith("ffprobe.exe") }
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($ffplayExe, (Join-Path $destFolder "ffprobe.exe"), $true)
        $zip.Dispose()
    
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
    
        # Remove the downloaded zip file
        Remove-Item -Path $ffmpegPath -Force
        
        # Done!
        Write-Host "`n`nFFmpeg is now installed! You can now close this window if it stays open." -ForegroundColor Green
        Write-Host "Should anything go wrong, your System/Machine PATH is displayed above."
        Write-Host "Closing in 2 seconds"
        Start-Sleep -Seconds 2
    }
}

function Install-aria2c() {
    Invoke-Elevated {
        Write-Host "Downloading Aria2c (A lightweight multi-protocol & multi-source command-line download utility)" -ForegroundColor Yellow
        # Set download URL and destination folder
        $downloadUrl = "https://github.com/aria2/aria2/releases/download/release-1.36.0/aria2-1.36.0-win-64bit-build1.zip"
        $destFolder = "C:\Tools"
        $aria2cZipPath = Join-Path $destFolder "aria2-1.36.0-win-64bit-build1.zip"
    
        # Create the destination folder if it doesn't exist
        if (!(Test-Path $destFolder)) {
            New-Item -ItemType Directory -Force -Path $destFolder
        }
    
        # Download the aria2c zip file
        Invoke-WebRequest -Uri $downloadUrl -OutFile $aria2cZipPath
    
        # Load assembly for ZipFile
        Add-Type -AssemblyName System.IO.Compression.FileSystem
    
        # Extract only aria2c.exe from the zip file
        $zip = [System.IO.Compression.ZipFile]::OpenRead($aria2cZipPath)
        $aria2cExe = $zip.Entries | Where-Object { $_.FullName.EndsWith("aria2c.exe") }
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($aria2cExe, (Join-Path $destFolder "aria2c.exe"), $true)
        $zip.Dispose()
    
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
    
        # Remove the downloaded zip file
        Remove-Item -Path $aria2cZipPath -Force
        
        # Done!
        Write-Host "`n`nAria2c is now installed! You can now close this window if it stays open." -ForegroundColor Green
        Write-Host "Should anything go wrong, your System/Machine PATH is displayed above."
        Write-Host "Closing in 2 seconds"
        Start-Sleep -Seconds 2
    }
}

function Install-Scrcpy() {
    Invoke-Elevated {
        Write-Host "Downloading SCRCPY (Screen Mirroring and Remote Control for Android devices)" -ForegroundColor Yellow
        # Set download URL and destination folder
        $downloadUrl = "https://github.com/Genymobile/scrcpy/releases/download/v2.0/scrcpy-win64-v2.0.zip"
        $destFolder = "C:\Tools"
        $scrcpyZipPath = Join-Path $destFolder "scrcpy-win64-v2.0.zip"
        $extractedFolderName = "scrcpy-win64-v2.0"
    
        # Create the destination folder if it doesn't exist
        if (!(Test-Path $destFolder)) {
            New-Item -ItemType Directory -Force -Path $destFolder
        }
    
        # Download the SCRCPY zip file
        Invoke-WebRequest -Uri $downloadUrl -OutFile $scrcpyZipPath
    
        # Load assembly for ZipFile
        Add-Type -AssemblyName System.IO.Compression.FileSystem
    
        # Extract everything from the specified folder inside the zip file
        $zip = [System.IO.Compression.ZipFile]::OpenRead($scrcpyZipPath)
        $entries = $zip.Entries | Where-Object { $_.FullName.StartsWith($extractedFolderName) }
        $extractedFolder = Join-Path $destFolder $extractedFolderName
        if (!(Test-Path $extractedFolder)) {
            New-Item -ItemType Directory -Force -Path $extractedFolder
        }
        foreach ($entry in $entries) {
            $relativePath = $entry.FullName.Substring($extractedFolderName.Length + 1)
            $extractedPath = Join-Path $extractedFolder $relativePath
            if ($entry.Length -eq 0) {
                New-Item -ItemType Directory -Force -Path $extractedPath
            } else {
                [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $extractedPath, $true)
            }
        }
        $zip.Dispose()
    
        # Remove the downloaded zip file
        Remove-Item -Path $scrcpyZipPath -Force
		
		$sourceFolder = "C:\Tools\scrcpy-win64-v2.0"
		$destinationFolder = "C:\Tools"

		# Create the destination folder if it doesn't exist
		if (!(Test-Path $destinationFolder)) {
			New-Item -ItemType Directory -Force -Path $destinationFolder
		}

		# Get all files and subfolders from the source folder
		$files = Get-ChildItem $sourceFolder -Recurse

		# Move each file to the destination folder
		foreach ($file in $files) {
			$destinationPath = Join-Path $destinationFolder $file.Name
			Move-Item -Path $file.FullName -Destination $destinationPath -Force
		}

		# Remove the source folder
		Remove-Item -Path $sourceFolder -Force

        
        # Done!
        Write-Host "`n`nSCRCPY is now installed! You can now close this window if it stays open." -ForegroundColor Green
        Write-Host "Closing in 2 seconds"
        Start-Sleep -Seconds 2
    }
}

function Install-YTDLP() {
    Invoke-Elevated {
        Write-Host "Downloading YT-DLP (download videos from youtube or other video platforms)" -ForegroundColor Yellow
        # Set download URL and destination folder
        $downloadUrl = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
        $destFolder = "C:\Tools"
        $ytDlpPath = Join-Path $destFolder "yt-dlp.exe"

        # Create the destination folder if it doesn't exist
        if (!(Test-Path $destFolder)) {
            New-Item -ItemType Directory -Force -Path $destFolder
        }

        # Download the yt-dlp.exe file
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

        Write-Host "Downloading YT-DLP-GUI (GUI for YT-DLP)" -ForegroundColor Yellow
        # Set download URL and destination folder
        $downloadUrl = "https://github.com/kannagi0303/yt-dlp-gui/releases/latest/download/yt-dlp-gui.exe"
        $destFolder = "C:\Tools"
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

        # Done!
        Write-Host "`n`nYT-DLP is now installed! You can now close this window if it stays open." -ForegroundColor Green
        Write-Host "Should anything go wrong, your System/Machine PATH is displayed above."
        Write-Host "Closing in 2 seconds"
        Start-Sleep -Seconds 2
    }
}

#---------------------------------------------------------------------------------
 
# Check if ffmpeg is installed
try {
    $ffmpegCommand = Get-Command ffmpeg -ErrorAction Stop
    Write-Host "ffmpeg is already installed." -ForegroundColor Yellow
} catch {
    Write-Host "ffmpeg is not installed. Installing..." -ForegroundColor Yellow
    Install-FFmpeg
}

# Check if yt-dlp is installed
try {
    $ytDlpCommand = Get-Command yt-dlp -ErrorAction Stop
    Write-Host "YT-DLP is already installed." -ForegroundColor Yellow
} catch {
    Write-Host "YT-DLP is not installed. Installing..." -ForegroundColor Yellow
    Install-YTDLP
}

# Check if aria2c is installed
try {
    $ariaCommand = Get-Command aria2c -ErrorAction Stop
    Write-Host "aria2c is already installed." -ForegroundColor Yellow
} catch {
    Write-Host "aria2c is not installed. Installing..." -ForegroundColor Yellow
    Install-aria2c
}

# Check if aria2c is installed
try {
    $ariaCommand = Get-Command scrcpy -ErrorAction Stop
    Write-Host "scrcpy is already installed." -ForegroundColor Yellow
} catch {
    Write-Host "scrcpy is not installed. Installing..." -ForegroundColor Yellow
    Install-Scrcpy
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
$Shortcut.TargetPath = "C:\Tools\yt-dlp-gui.exe"
$Shortcut.Save()

$downloadsDirectory = Join-Path -Path $scriptDirectory -ChildPath "yt-dlp\Downloads"
New-Item -ItemType Directory -Path $downloadsDirectory

# Done!
Write-Host "`n`nYT-DLP Scripts downloaded! You can now close this window if it stays open." -ForegroundColor Green
Write-Host "Should anything go wrong, your System/Machine PATH is displayed above."
Write-Host "Closing in 2 seconds"
Start-Sleep -Seconds 2