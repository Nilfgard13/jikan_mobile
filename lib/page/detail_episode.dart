import 'package:flutter/material.dart';
import 'package:jikan/model/Episode_detail.dart';
import 'package:jikan/service/Anime_Service.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodeDetailPage extends StatefulWidget {
  final int animeId;
  final int episodeId;

  const EpisodeDetailPage(
      {Key? key, required this.animeId, required this.episodeId})
      : super(key: key);

  @override
  _EpisodeDetailPageState createState() => _EpisodeDetailPageState();
}

class _EpisodeDetailPageState extends State<EpisodeDetailPage> {
  late Future<EpisodeDetail> futureEpisodeDetail;

  @override
  void initState() {
    super.initState();
    futureEpisodeDetail =
        AnimeService.fetchEpisodeDetail(widget.animeId, widget.episodeId);
  }

  String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episode Detail'),
      ),
      body: FutureBuilder<EpisodeDetail>(
        future: futureEpisodeDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          final episode = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Episode ${episode.malId}: ${episode.title}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (episode.titleJapanese != null)
                    Text(
                      episode.titleJapanese!,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  if (episode.titleRomanji != null)
                    Text(
                      episode.titleRomanji!,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Duration: ${formatDuration(episode.duration)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Aired: ${episode.aired}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      if (episode.filler)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Filler',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      if (episode.filler && episode.recap) SizedBox(width: 8),
                      if (episode.recap)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Recap',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (episode.synopsis != null) ...[
                    SizedBox(height: 24),
                    Text(
                      'Synopsis',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      episode.synopsis!,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                  SizedBox(height: 24),
                  if (episode.url.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () async {
                        final Uri url = Uri.parse(episode.url);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      icon: Icon(Icons.open_in_new),
                      label: Text('View on MyAnimeList'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
