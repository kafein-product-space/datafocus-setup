#!/usr/bin/env pwsh

# Prompt user for the hostname (default: http://localhost)
$defaultHostname = "http://localhost"
Write-Host "Enter the hostname. (default: $defaultHostname):"
$hostname = Read-Host
if ([string]::IsNullOrWhiteSpace($hostname)) {
    $hostname = $defaultHostname
}

# Set the environment variables using the provided hostname
$FE_URL = $hostname
$API_BASE_URL = "$hostname/api/datafocus-service"
$KEYCLOAK_URL = "$hostname/auth"
$MINIO_BROWSER_REDIRECT_URL = "$hostname/minio/"

# Extract KC_HOSTNAME by removing the protocol (http:// or https://)
$KC_HOSTNAME = $hostname -replace '^https?://', ''

# Display the final values
Write-Host "Updated values:"
Write-Host "FE_URL: $FE_URL"
Write-Host "API_BASE_URL: $API_BASE_URL"
Write-Host "KEYCLOAK_URL: $KEYCLOAK_URL"
Write-Host "MINIO_BROWSER_REDIRECT_URL: $MINIO_BROWSER_REDIRECT_URL"
Write-Host "KC_HOSTNAME (no protocol): $KC_HOSTNAME"

# Ask for confirmation before proceeding
Write-Host "Do you want to proceed with updating the docker-compose.yml file? (y/n)"
$confirmation = Read-Host

if ($confirmation -match '^[Yy]$') {
    # Proceed with updating the Docker Compose file
    # Replace the old values with the new ones using -replace
    $dockerComposeFile = "./docker-compose.yml"

    if (-not (Test-Path -Path $dockerComposeFile -PathType Leaf)) {
        Write-Error "Error: '$dockerComposeFile' not found."
        exit 1
    }

    try {
        # Read the content of docker-compose.yml
        $content = Get-Content -Path $dockerComposeFile

        # Update API_BASE_URL
        $content = $content -replace 'API_BASE_URL:.*', "API_BASE_URL: `"${API_BASE_URL}`""

        # Update KEYCLOAK_URL
        $content = $content -replace 'KEYCLOAK_URL:.*', "KEYCLOAK_URL: `"${KEYCLOAK_URL}`""

        # Update MINIO_BROWSER_REDIRECT_URL
        $content = $content -replace 'MINIO_BROWSER_REDIRECT_URL:.*', "MINIO_BROWSER_REDIRECT_URL: `"${MINIO_BROWSER_REDIRECT_URL}`""

        # Update KC_HOSTNAME
        $content = $content -replace 'KC_HOSTNAME:.*', "KC_HOSTNAME: `"${KC_HOSTNAME}`""

        # Save the updated content back to docker-compose.yml
        $content | Set-Content -Path $dockerComposeFile

        Write-Host "docker-compose.yml file has been updated successfully!"
    } catch {
        Write-Error "An error occurred while updating the docker-compose.yml file: $_"
        exit 1
    }
} else {
    Write-Host "Operation cancelled. No changes were made."
}

# Display the URLs for the user to access the application
Write-Host "You can access the application after the deployment using the following URLs:"
Write-Host "Frontend URL: $FE_URL"
