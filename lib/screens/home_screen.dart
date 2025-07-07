import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sound.dart';
import '../services/audio_player_service.dart';
//import '../widgets/category_tab.dart';
import '../widgets/sound_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _categories = ['Ambience', 'Music', 'Effects'];
  final Map<String, List<Sound>> _sounds = {
    'Ambience': [
      Sound(
        id: 'forest',
        name: 'Forest',
        assetPath: 'assets/audio/ambience/forest.mp3',
        category: 'Ambience',
        loop: true,
      ),
      Sound(
        id: 'tavern',
        name: 'Tavern',
        assetPath: 'assets/audio/ambience/tavern.mp3',
        category: 'Ambience',
        loop: true,
      ),
      Sound(
        id: 'rain',
        name: 'Rain',
        assetPath: 'assets/audio/ambience/rain.mp3',
        category: 'Ambience',
        loop: true,
      ),
      Sound(
        id: 'campfire',
        name: 'Campfire',
        assetPath: 'assets/audio/ambience/campfire.mp3',
        category: 'Ambience',
        loop: true,
      ),
    ],
    'Music': [
      Sound(
        id: 'battle',
        name: 'Battle',
        assetPath: 'assets/audio/music/battle.mp3',
        category: 'Music',
        loop: true,
      ),
      Sound(
        id: 'exploration',
        name: 'Exploration',
        assetPath: 'assets/audio/music/exploration.mp3',
        category: 'Music',
        loop: true,
      ),
      Sound(
        id: 'calm',
        name: 'Calm',
        assetPath: 'assets/audio/music/calm.mp3',
        category: 'Music',
        loop: true,
      ),
      Sound(
        id: 'mystery',
        name: 'Mystery',
        assetPath: 'assets/audio/music/mystery.mp3',
        category: 'Music',
        loop: true,
      ),
    ],
    'Effects': [
      Sound(
        id: 'sword',
        name: 'Sword',
        assetPath: 'assets/audio/effects/sword.mp3',
        category: 'Effects',
        loop: false,
      ),
      Sound(
        id: 'magic',
        name: 'Magic',
        assetPath: 'assets/audio/effects/magic.mp3',
        category: 'Effects',
        loop: false,
      ),
      Sound(
        id: 'door',
        name: 'Door',
        assetPath: 'assets/audio/effects/door.mp3',
        category: 'Effects',
        loop: false,
      ),
      Sound(
        id: 'explosion',
        name: 'Explosion',
        assetPath: 'assets/audio/effects/explosion.mp3',
        category: 'Effects',
        loop: false,
      ),
    ],
  };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SoundForge'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 80),
        children: _categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    category,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 8),
                SoundGrid(sounds: _sounds[category] ?? []),
              ],
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AudioPlayerService>().stopAllSounds();
        },
        child: const Icon(Icons.stop),
      ),
    );
  }
}
