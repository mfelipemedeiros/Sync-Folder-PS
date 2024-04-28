
function Sync-Folders {
    # Source and destination folder paths
    $sourceFolder = Read-Host "Define the folder to be synchronized: "
    $destinationFolder = Read-Host "Define the destination path: "
    $logDestinationFolder = Read-Host "Defines the log destination path: "
    $logDestinationFolder = $logDestinationFolder + "\LogsPS.txt"
    Write-Host $logDestinationFolder
    # Function to synchronize folders
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
                $mensagem = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') File copied: $($file.FullName) -> $destinationPath"
                Write-Host $mensagem
                Add-Content -Path $logDestinationFolder -Value $mensagem
            }
        }

        # Remove files from destination that don't exist in source
        foreach ($file in $destinationFiles) {
            $sourcePath = Join-Path $sourceFolder $file.Name
            # Check if file exists in source
            if (-not (Test-Path $sourcePath)) {
                Remove-Item -Path $file.FullName -Force
                $mensagem = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') File deleted: $($file.FullName)"
                Write-Host $mensagem
                Add-Content -Path $logDestinationFolder -Value $mensagem
            }
        }

        # Wait for a specified interval before checking again
        Start-Sleep -Seconds 60  # Adjust the interval as needed
    }
}

# Call the function to start synchronization
Sync-Folders
