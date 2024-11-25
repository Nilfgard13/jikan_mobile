// lib/main.dart
import 'package:flutter/material.dart';
import 'package:jikan/page/anime_list.dart';

void main() {
  runApp(AnimeApp());
}

class AnimeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AnimeListPage(),
    );
  }
}