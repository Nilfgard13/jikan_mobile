class Character {
  final int malId;
  final String name;
  final String imageUrl;
  final String role;

  Character({
    required this.malId,
    required this.name,
    required this.imageUrl,
    required this.role,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      malId: json['character']['mal_id'],
      name: json['character']['name'],
      imageUrl: json['character']['images']['jpg']['image_url'],
      role: json['role'],
    );
  }
}
