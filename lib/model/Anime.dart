// lib/models/anime.dart
import 'Character.dart';
import 'Staffs.dart';

class Anime {
  final int malId;
  final String title;
  final String imageUrl;
  final String synopsis;
  final double score;
  final String type;
  final int episodes;
  final String status;
  final List<String> genres;
  final List<Character> characters;
  final List<Staffs> staffs;

  Anime({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.synopsis,
    required this.score,
    required this.type,
    required this.episodes,
    required this.status,
    required this.genres,
    required this.characters,
    required this.staffs,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['images']['jpg']['large_image_url'],
      synopsis: json['synopsis'] ?? 'No synopsis available',
      score: (json['score'] ?? 0.0).toDouble(),
      type: json['type'] ?? 'Unknown',
      episodes: json['episodes'] ?? 0,
      status: json['status'] ?? 'Unknown',
      genres: (json['genres'] as List?)
              ?.map((genre) => genre['name'] as String)
              .toList() ??
          [],
      characters: (json['characters'] as List<dynamic>?)
              ?.map((characterJson) => Character.fromJson(characterJson))
              .toList() ??
          [],
      staffs: (json['staff'] as List?)
              ?.map((staffJson) => Staffs.fromJson(staffJson))
              .toList() ??
          [],
    );
  }
}
