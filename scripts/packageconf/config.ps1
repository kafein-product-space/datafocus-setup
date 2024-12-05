#!/usr/bin/env pwsh

# Parameter block must be at the top of the script
param (
    [Parameter(Mandatory = $true)]
    [string]$FunctionName
)

# Main configuration script
# Usage: ./config.ps1 <function_name>

# Base directory for the script files
$SCRIPT_DIR = "./scripts"

# Path to the docker-compose.yml file
$DOCKER_COMPOSE_FILE = "./docker-compose.yml"

# Backup directory (can be customized)
$BACKUP_DIR = "./backups"

if (-not $FunctionName) {
    Write-Host "Usage: ./config.ps1 <function_name>"
    Write-Host "Available functions:"
    Get-ChildItem -Path $SCRIPT_DIR -Filter *.ps1 | ForEach-Object {
        Write-Host "  - $($_.BaseName)"
    }
    exit 1
}

# Map the function name to a script in the scripts directory
$SCRIPT_FILE = Join-Path -Path $SCRIPT_DIR -ChildPath "$FunctionName.ps1"

# Check if the script exists
if (-not (Test-Path -Path $SCRIPT_FILE -PathType Leaf)) {
    Write-Error "Error: Function '$FunctionName' not found."
    Write-Host "Check available functions with: ./config.ps1"
    exit 1
}

# Backup docker-compose.yml file function
function Backup-DockerCompose {
    # Check if the docker-compose.yml exists
    if (-not (Test-Path -Path $DOCKER_COMPOSE_FILE -PathType Leaf)) {
        Write-Error "Error: '$DOCKER_COMPOSE_FILE' not found."
        exit 1
    }

    # Create the backup directory if it doesn't exist
    if (-not (Test-Path -Path $BACKUP_DIR -PathType Container)) {
        New-Item -ItemType Directory -Path $BACKUP_DIR | Out-Null
    }

    # Get the current time for the backup filename
    $timestamp = Get-Date -Format "HH-mm"

    # Define the backup file name
    $BACKUP_FILE = Join-Path -Path $BACKUP_DIR -ChildPath "docker-compose.yml-$timestamp"

    # Perform the backup
    try {
        Copy-Item -Path $DOCKER_COMPOSE_FILE -Destination $BACKUP_FILE -Force
        Write-Host "Backup of '$DOCKER_COMPOSE_FILE' created at '$BACKUP_FILE'."
    } catch {
        Write-Error "Error: Failed to create backup."
        exit 1
    }
}

# Perform the backup before running the function
Backup-DockerCompose

# Execute the selected script
try {
    & $SCRIPT_FILE @Args
} catch {
    Write-Error "Error while executing the script: $_"
    exit 1
}
