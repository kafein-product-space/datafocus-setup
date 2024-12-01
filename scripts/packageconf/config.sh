#!/bin/bash

# Main configuration script
# Usage: ./config.sh <function_name>

# Base directory for the script files
SCRIPT_DIR="./scripts"

# Path to the docker-compose.yml file
DOCKER_COMPOSE_FILE="./docker-compose.yml"

# Backup directory (can be customized)
BACKUP_DIR="./backups"

# Check if a function name is provided
if [[ -z $1 ]]; then
    echo "Usage: $0 <function_name>"
    echo "Available functions:"
    for script in "$SCRIPT_DIR"/*.sh; do
        script_name=$(basename "$script" .sh)
        echo "  - $script_name"
    done
    exit 1
fi

# Capture the function name
FUNCTION_NAME=$1

# Map the function name to a script in the scripts directory
SCRIPT_FILE="$SCRIPT_DIR/${FUNCTION_NAME}.sh"

# Check if the script exists
if [[ ! -f $SCRIPT_FILE ]]; then
    echo "Error: Function '$FUNCTION_NAME' not found."
    echo "Check available functions with: $0"
    exit 1
fi

# Backup docker-compose.yml file function
backup_docker_compose() {
    # Check if the docker-compose.yml exists
    if [[ ! -f "$DOCKER_COMPOSE_FILE" ]]; then
        echo "Error: '$DOCKER_COMPOSE_FILE' not found."
        exit 1
    fi

    # Create the backup directory if it doesn't exist
    mkdir -p "$BACKUP_DIR"

    # Get the current time for the backup filename
    TIMESTAMP=$(date +"%H-%M")

    # Define the backup file name
    BACKUP_FILE="${BACKUP_DIR}/docker-compose.yml-${TIMESTAMP}"

    # Perform the backup
    cp "$DOCKER_COMPOSE_FILE" "$BACKUP_FILE"

    if [[ $? -eq 0 ]]; then
        echo "Backup of '$DOCKER_COMPOSE_FILE' created at '$BACKUP_FILE'."
    else
        echo "Error: Failed to create backup."
        exit 1
    fi
}

# If backup is requested, perform the backup before running the function
backup_docker_compose

# Execute the selected script
bash "$SCRIPT_FILE" "${@:2}"
