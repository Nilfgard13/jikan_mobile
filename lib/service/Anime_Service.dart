// lib/services/anime_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jikan/model/Anime.dart';
import 'package:jikan/model/Character.dart';

class AnimeService {
  static Future<List<Anime>> fetchAnimeList() async {
    final response = await http.get(
      Uri.parse('https://api.jikan.moe/v4/seasons/now'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body)['data'];
      return body.map((dynamic item) => Anime.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load anime list');
    }
  }

  static Future<Anime> fetchAnimeDetails(int malId) async {
    final response = await http.get(
      Uri.parse('https://api.jikan.moe/v4/anime/$malId/full'),
    );

    if (response.statusCode == 200) {
      final dynamic body = json.decode(response.body)['data'];
      return Anime.fromJson(body);
    } else {
      throw Exception('Failed to load anime details');
    }
  }

  static Future<List<Character>> fetchAnimeDetailsCharacter(int malId) async {
    final response = await http.get(
      Uri.parse('https://api.jikan.moe/v4/anime/$malId/characters'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> charactersJson = json.decode(response.body)['data'];
      return charactersJson
          .map((characterJson) => Character.fromJson(characterJson))
          .toList();
    } else {
      throw Exception('Failed to load anime characters');
    }
  }

  static Future<List<Character>> fetchAnimeDetailsStaffs(int malId) async {
    final response = await http.get(
      Uri.parse('https://api.jikan.moe/v4/anime/$malId/staff'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> charactersJson = json.decode(response.body)['data'];
      return charactersJson
          .map((characterJson) => Character.fromJson(characterJson))
          .toList();
    } else {
      throw Exception('Failed to load anime characters');
    }
  }
}
