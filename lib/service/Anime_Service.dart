// lib/services/anime_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jikan/model/Anime.dart';
import 'package:jikan/model/Character.dart';
import 'package:jikan/model/Staffs.dart';
import 'package:jikan/model/Schedule.dart';

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

  static Future<List<Staffs>> fetchAnimeDetailsStaffs(int malId) async {
    final response = await http.get(
      Uri.parse('https://api.jikan.moe/v4/anime/$malId/staff'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> staffsJson = json.decode(response.body)['data'];
      return staffsJson.map((staff) => Staffs.fromJson(staff)).toList();
    } else {
      throw Exception('Failed to load anime characters');
    }
  }

  static Future<List<Anime>> fetchAnimeSearch(int malId) async {
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

  Future<List<AnimeSchedule>> getAnimeSchedule({String? filter}) async {
    try {
      final url = Uri.parse(
          'https://api.jikan.moe/v4/schedules${filter != null ? "?filter=$filter" : ""}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> animeList = data['data'];
        return animeList.map((anime) => AnimeSchedule.fromJson(anime)).toList();
      } else {
        throw Exception('Failed to load anime schedule');
      }
    } catch (e) {
      throw Exception('Error fetching anime schedule: $e');
    }
  }
}
