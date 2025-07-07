import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../models/sound.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerService extends ChangeNotifier {
  final Map<String, AudioPlayer> _activePlayers = {};
  final Map<String, Sound> _activeSounds = {};
  final Map<String, double> _soundVolumes = {};
  final Map<String, double> _categoryVolumes = {
    'Ambiance': 1.0,
    'Music': 1.0,
    'Effects': 1.0,
  };

  final AudioPlayer _backgroundPlayer = AudioPlayer();

  Future<void> _fadeVolume(
      AudioPlayer player, double start, double end, Duration duration) async {
    const int steps = 20;
    final double step = (end - start) / steps;
    final Duration stepDuration = duration ~/ steps;

    for (int i = 1; i <= steps; i++) {
      final double volume = start + step * i;
      await player.setVolume(volume);
      await Future.delayed(stepDuration);
    }
    await player.setVolume(end);
  }

  Future<void> playSound(Sound sound) async {
    if (_activePlayers.containsKey(sound.id)) {
      await stopSound(sound.id);
    }

    final player = AudioPlayer();
    _activePlayers[sound.id] = player;
    _activeSounds[sound.id] = sound;
    _soundVolumes[sound.id] = sound.volume;

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

      await player.setVolume(0.0);
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

      final targetVolume =
          sound.volume * (_categoryVolumes[sound.category] ?? 1.0);
      _fadeVolume(player, 0.0, targetVolume, const Duration(seconds: 1));
    } catch (e) {
      debugPrint('Error playing sound: $e');
      _disposePlayer(sound.id);
    }
  }

  Future<void> stopSound(String soundId) async {
    final playersToStop =
        _activePlayers.entries.where((entry) => entry.key == soundId).toList();

    for (var entry in playersToStop) {
      final player = entry.value;
      final currentVolume = player.volume;
      await _fadeVolume(player, currentVolume, 0.0, const Duration(seconds: 1));
      await player.stop();
      _disposePlayer(entry.key);
    }
  }

  Future<void> setSoundVolume(String soundId, double volume) async {
    final player = _activePlayers[soundId];
    _soundVolumes[soundId] = volume;
    final sound = _activeSounds[soundId];
    if (player != null && sound != null) {
      final catVolume = _categoryVolumes[sound.category] ?? 1.0;
      await player.setVolume(volume * catVolume);
    }
  }

  double getCategoryVolume(String category) =>
      _categoryVolumes[category] ?? 1.0;

  Future<void> setCategoryVolume(String category, double volume) async {
    _categoryVolumes[category] = volume;
    for (var entry in _activePlayers.entries) {
      final sound = _activeSounds[entry.key];
      if (sound != null && sound.category == category) {
        final soundVol = _soundVolumes[entry.key] ?? 1.0;
        await entry.value.setVolume(soundVol * volume);
      }
    }
    notifyListeners();
  }

  Future<void> stopAllSounds() async {
    for (var entry in _activePlayers.entries.toList()) {
      await stopSound(entry.key);
    }
  }

  void _disposePlayer(String soundId) {
    final player = _activePlayers[soundId];
    if (player != null) {
      player.dispose();
      _activePlayers.remove(soundId);
      _activeSounds.remove(soundId);
      _soundVolumes.remove(soundId);
    }
  }

  @override
  void dispose() {
    stopAllSounds();
    _backgroundPlayer.dispose();
    super.dispose();
  }
}
