import 'package:flutter/material.dart';
import 'package:jikan/model/Anime.dart';
import 'package:jikan/model/Character.dart'; // Import Character model
import 'package:jikan/model/Staffs.dart'; // Import Character model
import 'package:jikan/model/Episode.dart'; // Import Character model
import 'package:jikan/service/Anime_Service.dart';
import 'detail_episode.dart';

class AnimeDetailPage extends StatefulWidget {
  final int malId;

  const AnimeDetailPage({Key? key, required this.malId}) : super(key: key);

  @override
  _AnimeDetailPageState createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  late Future<List<dynamic>> futureCombined;

  @override
  void initState() {
    super.initState();
    futureCombined = Future.wait([
      AnimeService.fetchAnimeDetails(widget.malId),
      AnimeService.fetchAnimeDetailsCharacter(widget.malId),
      AnimeService.fetchAnimeDetailsStaffs(widget.malId),
      AnimeService.fetchAnimeEpisodes(widget.malId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime Details'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureCombined,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          final anime = snapshot.data![0] as Anime;
          final characters = snapshot.data![1] as List<Character>;
          final staffs = snapshot.data![2] as List<Staffs>;
          final episodes = snapshot.data![3] as List<Episode>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  anime.imageUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anime.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Score: ${anime.score}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 20),
                          Text('Type: ${anime.type}'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text('Episodes: ${anime.episodes}'),
                      Text('Status: ${anime.status}'),
                      SizedBox(height: 10),
                      Text(
                        'Genres: ${anime.genres.join(", ")}',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Synopsis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        anime.synopsis,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Characters',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              characters.take(6).length, // Batasi hanya 6 item
                          itemBuilder: (context, index) {
                            final character = characters[index];
                            return Container(
                              width: 120,
                              margin: EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundImage:
                                        NetworkImage(character.imageUrl),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    character.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    character.role,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Staffs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              staffs.take(6).length, // Menggunakan staffs
                          itemBuilder: (context, index) {
                            final staff = staffs[index]; // Menggunakan staffs
                            return Container(
                              width: 120,
                              margin: EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundImage:
                                        NetworkImage(staff.imageUrl),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    staff.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    staff.positions.join(
                                        ", "), // Mengkonversi List<String> menjadi String dengan pemisah koma
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Episodes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: episodes.length,
                        itemBuilder: (context, index) {
                          final episode = episodes[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 0),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EpisodeDetailPage(
                                      animeId: anime
                                          .malId, // Pastikan episode memiliki animeId
                                      episodeId: episode
                                          .malId, // Menggunakan malId sebagai episodeId
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                'Episode ${episode.malId}: ${episode.title}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (episode.titleJapanese != null &&
                                      episode.titleJapanese!.isNotEmpty)
                                    Text(
                                      episode.titleJapanese!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  if (episode.titleRomanji != null &&
                                      episode.titleRomanji!.isNotEmpty)
                                    Text(
                                      episode.titleRomanji!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  Text(
                                    'Aired: ${episode.aired}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Row(
                                    children: [
                                      if (episode.score > 0)
                                        Text(
                                          'Score: ${episode.score.toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      SizedBox(width: 10),
                                      if (episode.filler)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'Filler',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      if (episode.recap)
                                        Container(
                                          margin: EdgeInsets.only(left: 6),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'Recap',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
