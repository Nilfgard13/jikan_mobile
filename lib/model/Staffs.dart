class Staffs {
  final int malId;
  final String name;
  final String imageUrl;
  // final String positions;
  final List<String> positions;

  Staffs({
    required this.malId,
    required this.name,
    required this.imageUrl,
    required this.positions,
  });

  factory Staffs.fromJson(Map<String, dynamic> json) {
    return Staffs(
      malId: json['person']['mal_id'],
      name: json['person']['name'],
      imageUrl: json['person']['images']['jpg']['image_url'],
      positions: (json['positions'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }
}
