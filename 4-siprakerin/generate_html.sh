#!/bin/bash

# Define the base path and GitHub raw URL base
# basePath="/home/tesar/Desktop/lap-harian/3-frappe"
basePath="/home/tesar/UBIG-Laporan-Harian/4-siprakerin"
# basePath="/home/tesar/Desktop/lap-harian/2-botpress-nobox"
baseUrl="https://raw.githubusercontent.com/tesarrm/UBIG-Laporan-Harian/main/4-siprakerin"

# Function to generate HTML content
generate_html_content() {
    folderPath=$1
    relativePath=$2

    # Read the content of teks.md
    teksFilePath="$folderPath/teks.md"
    if [ ! -f "$teksFilePath" ]; then
        echo "File teks.md not found!"
        return
    fi
    teksContent=$(cat "$teksFilePath")

    # Check if teks.md is empty
    if [ -z "$teksContent" ]; then
        return
    fi

    # Extract YouTube URL if present
    youtubeEmbed=""
    if [[ $teksContent =~ https:\/\/youtu\.be\/([^\s]+) ]]; then
        youtubeId=${BASH_REMATCH[1]}
        youtubeEmbed="<iframe frameborder='0' src='//www.youtube.com/embed/$youtubeId' width='640' height='360' class='note-video-clip'></iframe><br><br>"
        # Remove YouTube link from teksContent
        teksContent=$(echo "$teksContent" | sed "s|https:\/\/youtu\.be\/[^\s]*||g")
    fi

    # Get list of images
    imageFolderPath="$folderPath/gambar"
    images=$(find "$imageFolderPath" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg"  \) | sort)


    # Start building the HTML content
    htmlContent=$(cat <<-END
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
END
    )

    # Add YouTube embed if present
    if [ -n "$youtubeEmbed" ]; then
        htmlContent+="$youtubeEmbed"
    fi

    htmlContent+=$(cat <<-END
        <div class="text-content">
            <pre>$teksContent</pre>
        </div>
        <div class="grid-container">
END
    )

    # Add images to the HTML content
    imageCount=$(echo "$images" | wc -l)
    i=0
    while IFS= read -r image; do
        imageName=$(basename "$image")
        imageUrl="$baseUrl/$relativePath/gambar/$imageName"
        if (( $imageCount % 2 == 1 && $i == 0 )); then
            # If the number of images is odd, make the first image span 2 columns
            htmlContent+="<div class='grid-item full-width'><img src='$imageUrl' alt='Image'></div>"
        else
            htmlContent+="<div class='grid-item'><img src='$imageUrl' alt='Image'></div>"
        fi
        ((i++))
    done <<< "$images"

    # Close the HTML content
    htmlContent+=$(cat <<-END
        </div>
    </div>
</body>
</html>
END
    )

    echo "$htmlContent"
}

# Loop through each folder
folders=$(find "$basePath" -mindepth 1 -maxdepth 1 -type d)
for folder in $folders; do
    relativePath=$(basename "$folder")
    htmlContent=$(generate_html_content "$folder" "$relativePath")

    # Only write the HTML file if the content is not null
    if [ -n "$htmlContent" ]; then
        # Write the HTML content to an index.html file in each folder
        outputFilePath="$folder/index.html"
        echo "$htmlContent" > "$outputFilePath"
    fi
done
