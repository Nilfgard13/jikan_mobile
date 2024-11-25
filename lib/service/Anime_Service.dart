// lib/services/anime_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jikan/model/Anime.dart';

class AnimeService {
  static Future<List<Anime>> fetchAnimeList() async {
    final response = await http.get(
      Uri.parse('https://api.jikan.moe/v4/anime'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body)['data'];
      return body.map((dynamic item) => Anime.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load anime list');
    }
  }
}