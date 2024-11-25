// lib/models/anime.dart
class Anime {
  final int malId;
  final String title;
  final String imageUrl;
  final String synopsis;
  final double score;

  Anime({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.synopsis,
    required this.score,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['images']['jpg']['image_url'],
      synopsis: json['synopsis'] ?? 'No synopsis available',
      score: (json['score'] ?? 0.0).toDouble(),
    );
  }
}