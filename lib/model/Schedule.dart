class AnimeSchedule {
  final int malId;
  final String title;
  final String imageUrl;
  final String synopsis;
  final String day;
  final double score;

  AnimeSchedule({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.synopsis,
    required this.day,
    required this.score,
  });

  factory AnimeSchedule.fromJson(Map<String, dynamic> json) {
    return AnimeSchedule(
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['images']['jpg']['image_url'],
      synopsis: json['synopsis'] ?? 'No synopsis available',
      day: json['broadcast']['day'] ?? 'Unknown',
      score: (json['score'] ?? 0.0).toDouble(),
    );
  }
}