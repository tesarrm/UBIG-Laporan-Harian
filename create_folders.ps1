# Define the start and end date
$startDate = [datetime]::ParseExact("26-02-2024", "dd-MM-yyyy", $null)
$endDate = [datetime]::ParseExact("30-12-2024", "dd-MM-yyyy", $null)

# Function to get the day name in Indonesian
function Get-IndonesianDayName {
    param (
        [datetime]$date
    )
    switch ($date.DayOfWeek) {
        'Monday' { return 'senin' }
        'Tuesday' { return 'selasa' }
        'Wednesday' { return 'rabu' }
        'Thursday' { return 'kamis' }
        'Friday' { return 'jumat' }
        'Saturday' { return 'sabtu' }
        'Sunday' { return 'minggu' }
    }
}

# Initialize counter for prefix
$counter = 1

# Loop through each day in the date range
$currentDate = $startDate
while ($currentDate -le $endDate) {
    # Skip Saturday and Sunday
    if ($currentDate.DayOfWeek -ne 'Saturday' -and $currentDate.DayOfWeek -ne 'Sunday') {
        # Get the day name in Indonesian
        $dayName = Get-IndonesianDayName -date $currentDate
        # Format the date and day of the week
        $folderName = "{0:D3}-{1:dd-MM-yyyy}-{2}" -f $counter, $currentDate, $dayName
        
        # Create the main folder
        $mainFolderPath = "C:\Users\Tesar\Desktop\lap-harian\$folderName"
        New-Item -Path $mainFolderPath -ItemType Directory -Force

        # Create subfolders
        New-Item -Path "$mainFolderPath\gambar" -ItemType Directory -Force
        New-Item -Path "$mainFolderPath\teks.md" -ItemType File -Force

        # Increment the counter
        $counter++
    }
    # Move to the next day
    $currentDate = $currentDate.AddDays(1)
}
