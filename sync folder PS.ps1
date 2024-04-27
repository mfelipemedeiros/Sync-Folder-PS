# Source and destination folder paths
$sourceFolder = Read-Host "Define the folder to be synchronized: "
$destinationFolder = Read-Host "Define the destination path: "

# Function to synchronize folders
function Sync-Folders {
    # Loop indefinitely
    while ($true) {
        # Get list of files in source folder
        $sourceFiles = Get-ChildItem -Path $sourceFolder -File

        # Get list of files in destination folder
        $destinationFiles = Get-ChildItem -Path $destinationFolder -File

        # Synchronize source to destination
        foreach ($file in $sourceFiles) {
            $destinationPath = Join-Path $destinationFolder $file.Name
            # Check if file exists in destination
            if (-not (Test-Path $destinationPath)) {
                Copy-Item -Path $file.FullName -Destination $destinationPath -Force
                Write-Host "File copied: $($file.FullName) -> $destinationPath"
            }
        }

        # Remove files from destination that don't exist in source
        foreach ($file in $destinationFiles) {
            $sourcePath = Join-Path $sourceFolder $file.Name
            # Check if file exists in source
            if (-not (Test-Path $sourcePath)) {
                Remove-Item -Path $file.FullName -Force
                Write-Host "File deleted: $($file.FullName)"
            }
        }

        # Wait for a specified interval before checking again
        Start-Sleep -Seconds 60  # Adjust the interval as needed
    }
}

# Call the function to start synchronization
Sync-Folders
