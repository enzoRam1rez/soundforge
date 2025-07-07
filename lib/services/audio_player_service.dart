import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:uuid/uuid.dart';
import '../models/sound.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerService extends ChangeNotifier {
  final Map<String, AudioPlayer> _activePlayers = {};
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final Uuid _uuid = const Uuid();

  Future<void> playSound(Sound sound) async {
    final player = AudioPlayer();
    final playerId = _uuid.v4();

    _activePlayers[playerId] = player;

    try {
      await player.setAudioSource(
        AudioSource.asset(
          sound.assetPath,
          tag: MediaItem(
            id: sound.id,
            title: sound.name,
            artUri: Uri.parse('asset:/assets/images/placeholder.png'),
          ),
        ),
      );

      player.setVolume(sound.volume);
      player.setLoopMode(sound.loop ? LoopMode.one : LoopMode.off);

      player.play().then((_) {
        if (!sound.loop) {
          player.playerStateStream.listen((state) {
            if (state.processingState == ProcessingState.completed) {
              _disposePlayer(playerId);
            }
          });
        }
      });
    } catch (e) {
      print('Error playing sound: $e');
      _disposePlayer(playerId);
    }
  }

  Future<void> stopSound(String soundId) async {
    final playersToStop =
        _activePlayers.entries.where((entry) => entry.key == soundId).toList();

    for (var entry in playersToStop) {
      await entry.value.stop();
      _disposePlayer(entry.key);
    }
  }

  Future<void> setVolume(String soundId, double volume) async {
    final player = _activePlayers[soundId];
    if (player != null) {
      await player.setVolume(volume);
    }
  }

  Future<void> stopAllSounds() async {
    for (var player in _activePlayers.values) {
      await player.stop();
    }
    _activePlayers.clear();
  }

  void _disposePlayer(String playerId) {
    final player = _activePlayers[playerId];
    if (player != null) {
      player.dispose();
      _activePlayers.remove(playerId);
    }
  }

  void dispose() {
    stopAllSounds();
    _backgroundPlayer.dispose();
  }
}
