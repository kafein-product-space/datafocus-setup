# Directory containing the Docker image packages
$DIR = Resolve-Path "./packages"

# Check if the directory exists
if (-not (Test-Path -Path $DIR -PathType Container)) {
    Write-Error "Error: Directory '$DIR' does not exist."
    exit 1
}

# List all .tar and .tar.gz files in the directory
Write-Host "Listing all .tar and .tar.gz files in '$DIR':"
$files = Get-ChildItem -Path $DIR -Filter "*.tar*" -File

# Check if any files are found
if ($files.Count -eq 0) {
    Write-Host "No .tar or .tar.gz files found in '$DIR'."
    exit 1
}

# Display the files
$files | ForEach-Object { Write-Host $_.FullName }

# Loop through all .tar and .tar.gz files in the directory
foreach ($tar_file in $files) {
    Write-Host "Loading $($tar_file.FullName) into Docker..."
    docker load --input $tar_file.FullName
}

Write-Host "All Docker images from '$DIR' have been loaded successfully!"
