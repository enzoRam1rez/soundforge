import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sound.dart';
import '../services/audio_player_service.dart';

class SoundGrid extends StatelessWidget {
  final List<Sound> sounds;
  
  const SoundGrid({
    super.key,
    required this.sounds,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: sounds.length,
      itemBuilder: (context, index) {
        return SoundButton(sound: sounds[index]);
      },
    );
  }
}

class SoundButton extends StatefulWidget {
  final Sound sound;
  
  const SoundButton({
    super.key,
    required this.sound,
  });

  @override
  State<SoundButton> createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton> {
  bool _isPlaying = false;
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _volume = widget.sound.volume;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Sound button
        GestureDetector(
          onTap: () {
            final audioService = context.read<AudioPlayerService>();
            if (_isPlaying) {
              audioService.stopSound(widget.sound.id);
              setState(() {
                _isPlaying = false;
              });
            } else {
              audioService.playSound(widget.sound.copyWith(volume: _volume));
              setState(() {
                _isPlaying = true;
              });
            }
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _isPlaying 
                  ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
                  : Theme.of(context).colorScheme.surfaceVariant,
              shape: BoxShape.circle,
              border: Border.all(
                color: _isPlaying 
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.outline,
                width: 2,
              ),
            ),
            child: Icon(
              _getIconForCategory(widget.sound.category),
              size: 40,
              color: _isPlaying 
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Sound name
        Text(
          widget.sound.name,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        // Volume slider always visible to allow adjusting before playback
        const SizedBox(height: 4),
        SizedBox(
          width: 80,
          child: Slider(
            value: _volume,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            onChanged: (value) {
              setState(() {
                _volume = value;
              });
              context.read<AudioPlayerService>().setVolume(
                    widget.sound.id,
                    value,
                  );
            },
          ),
        ),
      ],
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'ambience':
        return Icons.forest;
      case 'music':
        return Icons.music_note;
      case 'effects':
        return Icons.bolt;
      default:
        return Icons.audiotrack;
    }
  }
}
