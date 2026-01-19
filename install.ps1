Write-Host "EasyVim Installer for Windows" -ForegroundColor Cyan

# 1. Check for Neovim
if (-not (Get-Command "nvim" -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Neovim is not installed or not in PATH." -ForegroundColor Red
    Write-Host "Please install it first: winget install Neovim.Neovim"
    exit 1
}

$ConfigDir = "$env:LOCALAPPDATA\nvim"
$BackupDir = "$env:LOCALAPPDATA\nvim.bak." + (Get-Date -Format "yyyyMMdd.HHmmss")

# 2. Backup existing config
if (Test-Path $ConfigDir) {
    Write-Host "Backing up existing config to $BackupDir" -ForegroundColor Yellow
    Rename-Item -Path $ConfigDir -NewName $BackupDir
}

# 3. Install EasyVim
Write-Host "Installing EasyVim..." -ForegroundColor Green
$SourceDir = Get-Location

# Copy files instead of Symlink to avoid Admin requirement
Copy-Item -Path "$SourceDir\*" -Destination $ConfigDir -Recurse -Force

Write-Host "Success! EasyVim is installed." -ForegroundColor Green
Write-Host "Run 'nvim' to start."
