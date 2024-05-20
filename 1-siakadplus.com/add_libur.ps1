# Define the base path
$basePath = "C:\Users\Tesar\Desktop\lap-harian\1-siakadplus.com"

# Loop through each folder
$folders = Get-ChildItem -Path $basePath -Directory
foreach ($folder in $folders) {
    $teksFilePath = Join-Path $folder.FullName "teks.md"
    
    # Check if teks.md exists
    if (Test-Path $teksFilePath) {
        $teksContent = Get-Content $teksFilePath -Raw
        
        # Check if teks.md is empty
        if ([string]::IsNullOrWhiteSpace($teksContent)) {
            # Add "-libur" to the folder name if not already present
            if ($folder.Name -notlike "*-libur") {
                $newFolderName = "$($folder.Name)-libur"
                $newFolderPath = Join-Path $folder.Parent.FullName $newFolderName
                
                # Rename the folder
                Rename-Item -Path $folder.FullName -NewName $newFolderPath
            }
        }
    }
}
