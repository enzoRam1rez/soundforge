# Create silent audio files as placeholders
$audioFiles = @(
    @{ Category = "ambience"; Name = "forest.mp3"; Duration = 30 },
    @{ Category = "ambience"; Name = "tavern.mp3"; Duration = 30 },
    @{ Category = "ambience"; Name = "rain.mp3"; Duration = 30 },
    @{ Category = "music"; Name = "battle.mp3"; Duration = 180 },
    @{ Category = "music"; Name = "exploration.mp3"; Duration = 180 },
    @{ Category = "effects"; Name = "sword.mp3"; Duration = 2 },
    @{ Category = "effects"; Name = "magic.mp3"; Duration = 3 },
    @{ Category = "effects"; Name = "door.mp3"; Duration = 2 }
)

# Create directories if they don't exist
$directories = $audioFiles | ForEach-Object { "assets/audio/$($_.Category)" } | Sort-Object -Unique
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
}

# Create silent audio files using ffmpeg if available
try {
    $ffmpegAvailable = $null -ne (Get-Command ffmpeg -ErrorAction SilentlyContinue)
    
    foreach ($file in $audioFiles) {
        $outputPath = "assets/audio/$($file.Category)/$($file.Name)"
        
        if (-not (Test-Path $outputPath)) {
            if ($ffmpegAvailable) {
                # Create silent audio using ffmpeg
                ffmpeg -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 -t $($file.Duration) -c:a libmp3lame -q:a 9 $outputPath
                Write-Host "Created silent audio: $outputPath"
            } else {
                # Create empty file as fallback
                $null | Out-File -FilePath $outputPath -Encoding byte -Force
                Write-Host "Created empty file (install ffmpeg for silent audio): $outputPath"
            }
        } else {
            Write-Host "File already exists: $outputPath"
        }
    }
} catch {
    Write-Host "Error creating audio files: $_"
}
