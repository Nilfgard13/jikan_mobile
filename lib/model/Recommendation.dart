// lib/model/AnimeRecommendation.dart

class AnimeRecommendation {
  final String malId;
  final List<RecommendedAnime> entries;
  final String content;

  AnimeRecommendation({
    required this.malId,
    required this.entries,
    required this.content,
  });

  factory AnimeRecommendation.fromJson(Map<String, dynamic> json) {
    return AnimeRecommendation(
      malId: json['mal_id'] ?? '',
      entries: (json['entry'] as List<dynamic>)
          .map((entry) => RecommendedAnime.fromJson(entry))
          .toList(),
      content: json['content'] ?? '',
    );
  }
}

class RecommendedAnime {
  final int malId;
  final String url;
  final AnimeImages images;
  final String title;

  RecommendedAnime({
    required this.malId,
    required this.url,
    required this.images,
    required this.title,
  });

  factory RecommendedAnime.fromJson(Map<String, dynamic> json) {
    return RecommendedAnime(
      malId: json['mal_id'] ?? 0,
      url: json['url'] ?? '',
      images: AnimeImages.fromJson(json['images']),
      title: json['title'] ?? '',
    );
  }
}

class AnimeImages {
  final ImageSet jpg;
  final ImageSet webp;

  AnimeImages({
    required this.jpg,
    required this.webp,
  });

  factory AnimeImages.fromJson(Map<String, dynamic> json) {
    return AnimeImages(
      jpg: ImageSet.fromJson(json['jpg']),
      webp: ImageSet.fromJson(json['webp']),
    );
  }
}

class ImageSet {
  final String imageUrl;
  final String smallImageUrl;
  final String largeImageUrl;

  ImageSet({
    required this.imageUrl,
    required this.smallImageUrl,
    required this.largeImageUrl,
  });

  factory ImageSet.fromJson(Map<String, dynamic> json) {
    return ImageSet(
      imageUrl: json['image_url'] ?? '',
      smallImageUrl: json['small_image_url'] ?? '',
      largeImageUrl: json['large_image_url'] ?? '',
    );
  }
}
