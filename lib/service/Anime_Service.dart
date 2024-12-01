// lib/services/anime_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jikan/model/Anime.dart';
import 'package:jikan/model/Character.dart';
import 'package:jikan/model/Staffs.dart';
import 'package:jikan/model/Schedule.dart';
import 'package:jikan/model/Episode.dart';
import 'package:jikan/model/Episode_detail.dart';
import 'package:jikan/model/Recommendation.dart';

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

  static Future<List<Episode>> fetchAnimeEpisodes(int malId) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));

      final response = await http.get(
        Uri.parse('https://api.jikan.moe/v4/anime/$malId/episodes'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Check if 'data' exists and is a List
        if (jsonResponse.containsKey('data') && jsonResponse['data'] is List) {
          final List<dynamic> episodeList = jsonResponse['data'];
          return episodeList.map((json) => Episode.fromJson(json)).toList();
        } else {
          print('Invalid response format: ${response.body}');
          return [];
        }
      } else if (response.statusCode == 429) {
        // Handle rate limiting
        print('Rate limited. Waiting before retrying...');
        await Future.delayed(Duration(seconds: 2));
        return fetchAnimeEpisodes(malId); // Retry the request
      } else {
        print('Failed to load episodes. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load episodes');
      }
    } catch (e) {
      print('Error fetching episodes: $e');
      throw Exception('Error fetching episodes: $e');
    }
  }

  static Future<EpisodeDetail> fetchEpisodeDetail(
      int animeId, int episodeId) async {
    try {
      await Future.delayed(
          Duration(milliseconds: 500)); // Respect rate limiting

      final response = await http.get(
        Uri.parse(
            'https://api.jikan.moe/v4/anime/$animeId/episodes/$episodeId'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('data')) {
          return EpisodeDetail.fromJson(jsonResponse['data']);
        } else {
          print('Invalid response format: ${response.body}');
          throw Exception('Invalid response format');
        }
      } else if (response.statusCode == 429) {
        print('Rate limited. Waiting before retrying...');
        await Future.delayed(Duration(seconds: 2));
        return fetchEpisodeDetail(animeId, episodeId);
      } else {
        print(
            'Failed to load episode detail. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load episode detail');
      }
    } catch (e) {
      print('Error fetching episode detail: $e');
      throw Exception('Error fetching episode detail: $e');
    }
  }

  static Future<List<AnimeRecommendation>> fetchRecommendations() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.jikan.moe/v4/recommendations/anime'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((item) => AnimeRecommendation.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load recommendations');
      }
    } catch (e) {
      throw Exception('Error fetching recommendations: $e');
    }
  }
}
