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
              color: Theme.of(context).colorScheme.surfaceVariant,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  _getIconForSound(widget.sound.id),
                  size: 40,
                  color: _isPlaying
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _isPlaying
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
                        : Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: _isPlaying
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
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
              context
                  .read<AudioPlayerService>()
                  .setSoundVolume(widget.sound.id, value);
            },
          ),
        ),
      ],
    );
  }

  IconData _getIconForSound(String id) {
    switch (id) {
      case 'forest':
        return Icons.forest;
      case 'tavern':
        return Icons.local_bar;
      case 'rain':
        return Icons.water_drop;
      case 'campfire':
        return Icons.local_fire_department;
      case 'battle':
        return Icons.sports_martial_arts;
      case 'exploration':
        return Icons.travel_explore;
      case 'calm':
        return Icons.self_improvement;
      case 'mystery':
        return Icons.visibility;
      case 'sword':
        return Icons.security;
      case 'magic':
        return Icons.auto_fix_high;
      case 'door':
        return Icons.meeting_room;
      case 'explosion':
        return Icons.whatshot;
      default:
        return Icons.audiotrack;
    }
  }
}
