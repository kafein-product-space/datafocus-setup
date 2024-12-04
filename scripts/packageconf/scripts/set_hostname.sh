#!/bin/bash

# Prompt user for the hostname (default: http://localhost)
echo "Enter the hostname. (default: http://localhost):"
read -r HOSTNAME
HOSTNAME="${HOSTNAME:-http://localhost}"


# Set the environment variables using the provided hostname
FE_URL="${HOSTNAME}"
API_BASE_URL="${HOSTNAME}/api/datafocus-service"
KEYCLOAK_URL="${HOSTNAME}/auth"
MINIO_BROWSER_REDIRECT_URL="${HOSTNAME}/minio/"
KC_HOSTNAME=$(echo "$HOSTNAME" | sed -E 's#^https?://##')

# Display the final values
echo "Updated values:"
echo "FE_URL: $FE_URL"
echo "API_BASE_URL: $API_BASE_URL"
echo "KEYCLOAK_URL: $KEYCLOAK_URL"
echo "MINIO_BROWSER_REDIRECT_URL: $MINIO_BROWSER_REDIRECT_URL"
echo "KC_HOSTNAME (no protocol): $KC_HOSTNAME"

# Ask for confirmation before proceeding
echo "Do you want to proceed with updating the docker-compose.yml file? (y/n)"
read -r confirmation

if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    # Proceed with updating the Docker Compose file
    # Using sed to replace the old values with the new ones

    # Update FE_URL (it could be any value, not just the default)
    sed -i "s|API_BASE_URL:.*|API_BASE_URL: \${API_BASE_URL:-$API_BASE_URL}|g" docker-compose.yml
    sed -i "s|KEYCLOAK_URL:.*|KEYCLOAK_URL: \${KEYCLOAK_URL:-$KEYCLOAK_URL}|g" docker-compose.yml
    sed -i "s|MINIO_BROWSER_REDIRECT_URL:.*|MINIO_BROWSER_REDIRECT_URL: \${MINIO_BROWSER_REDIRECT_URL:-$MINIO_BROWSER_REDIRECT_URL}|g" docker-compose.yml
    sed -i "s|KC_HOSTNAME:.*|KC_HOSTNAME: \${KC_HOSTNAME:-$KC_HOSTNAME}|g" docker-compose.yml

    echo "docker-compose.yml file has been updated!"
else
    echo "Operation cancelled. No changes were made."
fi

# Display the URLs for the user to access the application
echo "You will access the application after the deployment using these URL in the browser:"
echo "Frontend URL: $FE_URL"
