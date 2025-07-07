# SoundForge - RPG Soundboard App

A Flutter-based soundboard application designed for tabletop RPG sessions. Play ambient sounds, music, and sound effects with ease during your gaming sessions.

## Features

- 🎵 Three main categories: Ambience, Music, and Effects
- 🔄 Loop support for continuous playback
- 🎚️ Individual volume control for each sound with a slider under every button
- 🎧 Multiple sounds can play simultaneously
- 🎮 Simple, intuitive interface
- 📱 Mobile-optimized design
- 🔌 100% offline functionality

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / Xcode (for emulator/simulator)
- Physical device (optional but recommended for testing)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/soundforge.git
   cd soundforge
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate placeholder audio files:
   - Install FFmpeg (recommended for silent audio) or
   - Run the PowerShell script to create empty files:
     ```powershell
     .\scripts\generate_placeholders.ps1
     ```

4. Run the app:
   ```bash
   flutter run
   ```

## Adding Your Own Sounds

1. Place your audio files in the appropriate directories:
   - `assets/audio/ambience/` - For ambient sounds
   - `assets/audio/music/` - For background music
   - `assets/audio/effects/` - For sound effects

2. Update the `_sounds` map in `lib/screens/home_screen.dart` to include your new sounds.

## Project Structure

```
lib/
├── main.dart               # App entry point
├── models/
│   └── sound.dart         # Sound model class
├── screens/
│   └── home_screen.dart   # Main screen with tab navigation
├── services/
│   └── audio_player_service.dart  # Handles audio playback
└── widgets/
    └── sound_grid.dart    # Grid view for sound buttons
```

## Dependencies

- `just_audio`: For audio playback
- `audio_session`: Manages audio focus
- `provider`: State management
- `uuid`: For unique sound identifiers

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Icons by [Material Icons](https://fonts.google.com/icons)
- Built with [Flutter](https://flutter.dev/)
