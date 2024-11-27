// First, update your Episode model (Episode.dart):
class Episode {
  final int malId;
  final String title;
  final String? titleJapanese;
  final String? titleRomanji;
  final double score;
  final String aired;
  final bool filler;
  final bool recap;
  final String? forumUrl;

  Episode({
    required this.malId,
    required this.title,
    this.titleJapanese,
    this.titleRomanji,
    required this.score,
    required this.aired,
    required this.filler,
    required this.recap,
    this.forumUrl,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      malId: json['mal_id'] ?? 0,
      title: json['title'] ?? 'No Title',
      titleJapanese: json['title_japanese'],
      titleRomanji: json['title_romanji'],
      score: (json['score'] ?? 0.0).toDouble(),
      aired: json['aired'] ?? 'Unknown',
      filler: json['filler'] ?? false,
      recap: json['recap'] ?? false,
      forumUrl: json['forum_url'],
    );
  }
}
