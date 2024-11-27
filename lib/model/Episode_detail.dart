class EpisodeDetail {
  final int malId;
  final String url;
  final String title;
  final String? titleJapanese;
  final String? titleRomanji;
  final int duration;
  final String aired;
  final bool filler;
  final bool recap;
  final String? synopsis;

  EpisodeDetail({
    required this.malId,
    required this.url,
    required this.title,
    this.titleJapanese,
    this.titleRomanji,
    required this.duration,
    required this.aired,
    required this.filler,
    required this.recap,
    this.synopsis,
  });

  factory EpisodeDetail.fromJson(Map<String, dynamic> json) {
    return EpisodeDetail(
      malId: json['mal_id'] ?? 0,
      url: json['url'] ?? '',
      title: json['title'] ?? 'No Title',
      titleJapanese: json['title_japanese'],
      titleRomanji: json['title_romanji'],
      duration: json['duration'] ?? 0,
      aired: json['aired'] ?? 'Unknown',
      filler: json['filler'] ?? false,
      recap: json['recap'] ?? false,
      synopsis: json['synopsis'],
    );
  }
}
