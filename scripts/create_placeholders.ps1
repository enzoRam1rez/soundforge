# Create directories if they don't exist
$directories = @(
    "assets/audio/ambience",
    "assets/audio/music",
    "assets/audio/effects",
    "assets/images"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
}

# Create placeholder audio files
$audioFiles = @(
    @{ Category = "ambience"; Name = "forest.mp3" },
    @{ Category = "ambience"; Name = "tavern.mp3" },
    @{ Category = "ambience"; Name = "rain.mp3" },
    @{ Category = "music"; Name = "battle.mp3" },
    @{ Category = "music"; Name = "exploration.mp3" },
    @{ Category = "effects"; Name = "sword.mp3" },
    @{ Category = "effects"; Name = "magic.mp3" },
    @{ Category = "effects"; Name = "door.mp3" }
)

foreach ($file in $audioFiles) {
    $filePath = "assets/audio/$($file.Category)/$($file.Name)"
    if (-not (Test-Path $filePath)) {
        [System.IO.File]::WriteAllBytes($filePath, @())
        Write-Host "Created placeholder: $filePath"
    } else {
        Write-Host "File already exists: $filePath"
    }
}

# Create a placeholder image
$placeholderImage = "assets/images/placeholder.png"
if (-not (Test-Path $placeholderImage)) {
    [System.IO.File]::WriteAllBytes($placeholderImage, @())
    Write-Host "Created placeholder image: $placeholderImage"
} else {
    Write-Host "Placeholder image already exists: $placeholderImage"
}

Write-Host "\nPlaceholder files created successfully!"
Write-Host "Replace these files with your actual audio files before distributing the app."
