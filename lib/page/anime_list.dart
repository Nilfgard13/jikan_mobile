// lib/pages/anime_list_page.dart
import 'package:flutter/material.dart';
import 'package:jikan/model/Anime.dart';
import 'package:jikan/service/Anime_Service.dart';
import 'detail_page.dart';

class AnimeListPage extends StatefulWidget {
  @override
  _AnimeListPageState createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  late Future<List<Anime>> futureAnimeList;

  @override
  void initState() {
    super.initState();
    futureAnimeList = AnimeService.fetchAnimeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime List'),
      ),
      body: FutureBuilder<List<Anime>>(
        future: futureAnimeList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No anime found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final anime = snapshot.data![index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.network(
                    anime.imageUrl,
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    anime.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anime.synopsis,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text('Score: ${anime.score}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnimeDetailPage(malId: anime.malId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}