import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../models/sound.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerService extends ChangeNotifier {
  final Map<String, AudioPlayer> _activePlayers = {};

  Future<void> playSound(Sound sound) async {
    // Stop the sound first if it's already playing to avoid duplicates
    if (_activePlayers.containsKey(sound.id)) {
      await stopSound(sound.id);
    }

    final player = AudioPlayer();
    _activePlayers[sound.id] = player;

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
              _disposePlayer(sound.id);
            }
          });
        }
      });
    } catch (e) {
      print('Error playing sound: $e');
      _disposePlayer(sound.id);
    }
  }

  Future<void> stopSound(String soundId) async {
    final player = _activePlayers[soundId];
    if (player != null) {
      await player.stop();
      _disposePlayer(soundId);
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
  }
}
