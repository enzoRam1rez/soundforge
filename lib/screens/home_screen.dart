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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, List<String>> _categoryGroups = {
    'Ambiance': ['Ambiance', 'Effects'],
    'Music': ['Music'],
  };

  final Map<String, List<Sound>> _sounds = {
    'Ambiance': [
      Sound(
        id: 'forest',
        name: 'Forest',
        assetPath: 'assets/audio/ambience/forest.mp3',
        category: 'Ambiance',
        loop: true,
      ),
      Sound(
        id: 'tavern',
        name: 'Tavern',
        assetPath: 'assets/audio/ambience/tavern.mp3',
        category: 'Ambiance',
        loop: true,
      ),
      Sound(
        id: 'rain',
        name: 'Rain',
        assetPath: 'assets/audio/ambience/rain.mp3',
        category: 'Ambiance',
        loop: true,
      ),
      Sound(
        id: 'campfire',
        name: 'Campfire',
        assetPath: 'assets/audio/ambience/campfire.mp3',
        category: 'Ambiance',
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
  void initState() {
    super.initState();
    _tabController = TabController(length: _categoryGroups.keys.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categoryGroups.keys.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SoundForge'),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            tabs: _categoryGroups.keys
                .map((g) => Tab(text: g))
                .toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _categoryGroups.keys.map((group) {
            final categories = _categoryGroups[group]!;
            return ListView(
              padding: const EdgeInsets.only(top: 16, bottom: 80),
              children:
                  categories.map((c) => _buildCategorySection(context, c)).toList(),
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<AudioPlayerService>().stopAllSounds();
          },
          child: const Icon(Icons.stop),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String category) {
    final sounds = _sounds[category] ?? [];
    final volume = context.watch<AudioPlayerService>().getCategoryVolume(category);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    category,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Slider(
                    value: volume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    onChanged: (val) {
                      context
                          .read<AudioPlayerService>()
                          .setCategoryVolume(category, val);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SoundGrid(sounds: sounds),
        ],
      ),
    );
  }
}
