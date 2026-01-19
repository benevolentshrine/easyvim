Write-Host "EasyVim Installer for Windows" -ForegroundColor Cyan

$InstallDir = "$env:USERPROFILE\.easyvim"
$BinDir = "$InstallDir\bin"
$ConfigDir = "$env:LOCALAPPDATA\nvim"
$BackupDir = "$env:LOCALAPPDATA\nvim.bak." + (Get-Date -Format "yyyyMMdd.HHmmss")

# 1. Prepare Directories
if (-not (Test-Path $InstallDir)) { New-Item -ItemType Directory -Path $InstallDir | Out-Null }
if (-not (Test-Path $BinDir)) { New-Item -ItemType Directory -Path $BinDir | Out-Null }

# 2. Check/Install Neovim
if (-not (Get-Command "nvim" -ErrorAction SilentlyContinue)) {
    Write-Host "Neovim not found. Downloading..." -ForegroundColor Yellow
    $NvimZip = "$InstallDir\nvim.zip"
    $Url = "https://github.com/neovim/neovim/releases/latest/download/nvim-win64.zip"
    
    Invoke-WebRequest -Uri $Url -OutFile $NvimZip
    Write-Host "Extracting Neovim..." -ForegroundColor Yellow
    Expand-Archive -Path $NvimZip -DestinationPath $BinDir -Force
    Remove-Item $NvimZip
    
    # Add to current session PATH
    $NvimExeDir = Get-ChildItem -Path $BinDir -Filter "nvim.exe" -Recurse | Select-Object -ExpandProperty DirectoryName -First 1
    $env:PATH += ";$NvimExeDir"
    
    # Persist PATH (User scope)
    [Environment]::SetEnvironmentVariable("Path", $env:PATH, [EnvironmentVariableTarget]::User)
}

# 3. Backup existing config
if (Test-Path $ConfigDir) {
    Write-Host "Backing up existing config to $BackupDir" -ForegroundColor Yellow
    Rename-Item -Path $ConfigDir -NewName $BackupDir
}

# 4. Install EasyVim Config
Write-Host "Installing configuration to $ConfigDir..." -ForegroundColor Green
if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir | Out-Null
}

$SourceDir = Get-Location
Copy-Item -Path "$SourceDir\*" -Destination $ConfigDir -Recurse -Force -Exclude ".git", "install.ps1", "install.sh"

# 5. Create Desktop Shortcut
$WshShell = New-Object -ComObject WScript.Shell
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$Shortcut = $WshShell.CreateShortcut("$DesktopPath\EasyVim.lnk")
$Shortcut.TargetPath = "nvim-qt.exe" # Gui version if available, else nvim
if (-not (Get-Command "nvim-qt" -ErrorAction SilentlyContinue)) {
    $Shortcut.TargetPath = "nvim.exe" 
}
$Shortcut.Description = "EasyVim Code Editor"
$Shortcut.Save()

Write-Host "Success! EasyVim is installed." -ForegroundColor Green
Write-Host "Shortcut created on Desktop."
Write-Host "You may need to restart your terminal for PATH changes."
Start-Sleep -Seconds 5
