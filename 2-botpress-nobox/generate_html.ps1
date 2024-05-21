# Define the base path and GitHub raw URL base
$basePath = "C:\Users\Tesar\Desktop\lap-harian\2-botpress-nobox"
# $basePath = "C:\Users\Tesar\Desktop\lap-harian\2-botpress-nobox"
$baseUrl = "https://raw.githubusercontent.com/tesarrm/UBIG-Laporan-Harian/main/2-botpress-nobox"

# Function to generate HTML content
function Generate-HTMLContent {
    param (
        [string]$folderPath,
        [string]$relativePath
    )

    # Read the content of teks.md
    $teksFilePath = Join-Path $folderPath "teks.md"
    $teksContent = Get-Content $teksFilePath -Raw

    # Check if teks.md is empty
    if ([string]::IsNullOrWhiteSpace($teksContent)) {
        return $null
    }

    # Extract YouTube URL if present
    $youtubeEmbed = ""
    if ($teksContent -match "https:\/\/youtu\.be\/([^\s]+)") {
        $youtubeId = $matches[1]
        $youtubeEmbed = "<iframe frameborder='0' src='//www.youtube.com/embed/$youtubeId' width='640' height='360' class='note-video-clip'></iframe><br><br>"
        # Remove YouTube link from teksContent
        $teksContent = $teksContent -replace "https:\/\/youtu\.be\/([^\s]+)", ""
    }

    # Get list of images
    $imageFolderPath = Join-Path $folderPath "gambar"
    $images = Get-ChildItem $imageFolderPath -Filter *.png | Sort-Object Name

    # Start building the HTML content
    $htmlContent = @"
<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>Laporan Harian</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .content { max-width: 800px; margin: auto; text-align: left !important; }
        .text-content { margin-bottom: 20px; }
        .grid-container { display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px; }
        .grid-item { border: 1px solid #ddd; padding: 10px; }
        .grid-item img { max-width: 100%; height: auto; display: block; }
        .full-width { grid-column: span 2; }
    </style>
</head>
<body>
    <div class="content">
"@

    # Add YouTube embed if present
    if ($youtubeEmbed) {
        $htmlContent += $youtubeEmbed + "`n"
    }

    $htmlContent += @"
        <div class="text-content">
            <pre>$teksContent</pre>
        </div>
        <div class="grid-container">
"@

    # Add images to the HTML content
    $imageCount = $images.Count
    for ($i = 0; $i -lt $imageCount; $i++) {
        $image = $images[$i]
        $imageUrl = "$baseUrl/$relativePath/gambar/$($image.Name)"
        if ($imageCount % 2 -eq 1 -and $i -eq 0) {
            # If the number of images is odd, make the first image span 2 columns
            $htmlContent += "<div class='grid-item full-width'><img src='$imageUrl' alt='Image'></div>`n"
        } else {
            $htmlContent += "<div class='grid-item'><img src='$imageUrl' alt='Image'></div>`n"
        }
    }

    # Close the HTML content
    $htmlContent += @"
        </div>
    </div>
</body>
</html>
"@

    return $htmlContent
}

# Loop through each folder
$folders = Get-ChildItem -Path $basePath -Directory
foreach ($folder in $folders) {
    $relativePath = $folder.Name
    $htmlContent = Generate-HTMLContent -folderPath $folder.FullName -relativePath $relativePath

    # Only write the HTML file if the content is not null
    if ($htmlContent) {
        # Write the HTML content to an index.html file in each folder
        $outputFilePath = Join-Path $folder.FullName "index.html"
        Set-Content -Path $outputFilePath -Value $htmlContent
    }
}
