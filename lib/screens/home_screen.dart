import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sound.dart';
import '../services/audio_player_service.dart';
import '../widgets/category_tab.dart';
import '../widgets/sound_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SoundForge'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          indicatorColor: Theme.of(context).colorScheme.secondary,
          labelColor: Theme.of(context).colorScheme.secondary,
          unselectedLabelColor: Colors.grey[400],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return SoundGrid(sounds: _sounds[category] ?? []);
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
