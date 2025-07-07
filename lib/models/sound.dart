class Sound {
  final String id;
  final String name;
  final String assetPath;
  final String category;
  final bool loop;
  double volume;

  Sound({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.category,
    this.loop = false,
    this.volume = 1.0,
  });

  Sound copyWith({
    String? id,
    String? name,
    String? assetPath,
    String? category,
    bool? loop,
    double? volume,
  }) {
    return Sound(
      id: id ?? this.id,
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      category: category ?? this.category,
      loop: loop ?? this.loop,
      volume: volume ?? this.volume,
    );
  }
}
