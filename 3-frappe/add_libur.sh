#!/bin/bash

# Define the base path
# basePath="/home/tesar/Desktop/lap-harian/3-frappe"
basePath="/home/tesar/UBIG-Laporan-Harian/3-frappe"

# Loop through each folder
for folder in "$basePath"/*/; do
    teksFilePath="$folder/teks.md"
    
    # Check if teks.md exists
    if [ -f "$teksFilePath" ]; then
        teksContent=$(<"$teksFilePath")
        
        # Check if teks.md is empty
        if [ -z "$teksContent" ]; then
            # Get the folder name without trailing slash
            folderName=$(basename "$folder")
            
            # Add "-libur" to the folder name if not already present
            if [[ "$folderName" != *"-libur" ]]; then
                newFolderName="${folderName}-libur"
                newFolderPath=$(dirname "$folder")/"$newFolderName"
                
                # Rename the folder
                mv "$folder" "$newFolderPath"
            fi
        fi
    fi
done
