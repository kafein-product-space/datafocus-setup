#!/bin/bash

# Directory containing the Docker image packages
DIR="./packages"

# Check if the directory exists
if [[ ! -d "$DIR" ]]; then
    echo "Error: Directory '$DIR' does not exist."
    exit 1
fi

# List all .tar and .tar.gz files in the directory
echo "Listing all .tar and .tar.gz files in '$DIR':"
ls -l "$DIR"/*.tar "$DIR"/*.tar.gz 2>/dev/null""

# Check if there are any .tar or .tar.gz files
if [[ ! "$(ls -A "$DIR"/*.tar 2>/dev/null)" && ! "$(ls -A "$DIR"/*.tar.gz 2>/dev/null)" ]]; then
    echo "No .tar or .tar.gz files found in '$DIR'."
    exit 1
fi

# Loop through all .tar files in the directory
for tar_file in "$DIR"/*.tar "$DIR"/*.tar.gz; do
    # Ensure file exists (in case of no matches)
    if [[ -e "$tar_file" ]]; then
        echo "Loading $tar_file into Docker..."
        docker load < "$tar_file"
    fi
done

echo "All Docker images from '$DIR' have been loaded successfully!"