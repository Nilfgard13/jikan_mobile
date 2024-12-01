import 'package:flutter/material.dart';
import 'package:jikan/model/Anime.dart';
import 'package:jikan/model/Character.dart';
import 'package:jikan/model/Staffs.dart';
import 'package:jikan/model/Episode.dart';
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
  // final mainBlue = Color(0xFF1A237E); // Deep Blue
  // final secondaryBlue = Color(0xFF3949AB); // Lighter Blue
  // final accentBlue = Color(0xFF42A5F5); // Light Blue

  final mainBlue = Color(0xFF1565C0); // Deeper blue
  final secondaryBlue = Color(0xFF2196F3); // Bright blue
  final grayBackground =
      const Color.fromARGB(255, 51, 51, 51); // Dark gray background
  final lightGray = Color(0xFF424242); // Lighter gray for cards

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
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        primaryColor: mainBlue,
        scaffoldBackgroundColor: grayBackground,
        cardColor: lightGray,
        colorScheme: ColorScheme.dark(
          primary: mainBlue,
          secondary: secondaryBlue,
          background: grayBackground,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        body: FutureBuilder<List<dynamic>>(
          future: futureCombined,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: secondaryBlue,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'No data found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final anime = snapshot.data![0] as Anime;
            final characters = snapshot.data![1] as List<Character>;
            final staffs = snapshot.data![2] as List<Staffs>;
            final episodes = snapshot.data![3] as List<Episode>;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      anime.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          anime.imageUrl,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                grayBackground.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Info Card
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: mainBlue,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.yellow, size: 20),
                                          SizedBox(width: 4),
                                          Text(
                                            '${anime.score}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Chip(
                                      label: Text(anime.type),
                                      backgroundColor: secondaryBlue,
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                _buildInfoRow(
                                    Icons.movie, 'Episodes: ${anime.episodes}'),
                                SizedBox(height: 8),
                                _buildInfoRow(Icons.info_outline,
                                    'Status: ${anime.status}'),
                                SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: anime.genres
                                      .map((genre) => Chip(
                                            label: Text(genre),
                                            backgroundColor: mainBlue,
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Synopsis Section
                        _buildSectionTitle('Synopsis'),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              anime.synopsis,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Characters Section
                        _buildSectionTitle('Characters'),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: characters.take(6).length,
                            itemBuilder: (context, index) {
                              final character = characters[index];
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.only(right: 16),
                                child: Container(
                                  width: 140,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(
                                            8.0), // Add padding around the image
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              NetworkImage(character.imageUrl),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              character.name,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              character.role,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 24),

                        // Staff Section
                        _buildSectionTitle('Staff'),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: staffs.take(6).length,
                            itemBuilder: (context, index) {
                              final staff = staffs[index];
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.only(
                                    right: 16, left: 16), // Added left margin
                                child: Container(
                                  width: 160, // Slightly increased width
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12), // Added overall padding
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 55, // Slightly larger avatar
                                        backgroundImage:
                                            NetworkImage(staff.imageUrl),
                                        backgroundColor: Colors.grey[
                                            200], // Added background color
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(
                                            10.0), // Slightly increased padding
                                        child: Column(
                                          children: [
                                            Text(
                                              staff.name,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    15, // Slightly larger font
                                                color: const Color.fromARGB(255, 255, 255, 255), // Added slight color variation
                                              ),
                                            ),
                                            SizedBox(
                                                height: 6), // Adjusted spacing
                                            Text(
                                              staff.positions.join(
                                                  " • "), // Used • separator instead of comma
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[
                                                    700], // Slightly darker grey
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 24),

                        // Episodes Section
                        _buildSectionTitle('Episodes'),
                        SizedBox(height: 10),
                        ExpansionTile(
                          title: Row(
                            children: [
                              Icon(
                                Icons.play_circle_fill,
                                color: Colors.blueAccent, // Ikon animasi
                                size: 28,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Episodes (${episodes.length})',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            'Tap to explore all episodes',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          backgroundColor: const Color.fromARGB(255, 33, 33, 33),
                          collapsedBackgroundColor: const Color.fromARGB(255, 51, 51, 51),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16), // Sudut melengkung
                            side: BorderSide(
                              color: Colors.grey[400]!,
                              width: 1,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.blueAccent,
                              width: 1.5,
                            ),
                          ),
                          collapsedTextColor: const Color.fromARGB(255, 56, 56, 56),
                          textColor: Colors.blue,
                          collapsedIconColor: const Color.fromARGB(255, 56, 56, 56),
                          iconColor: Colors.blue,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: episodes.length,
                              itemBuilder: (context, index) {
                                final episode = episodes[index];
                                return Card(
                                  elevation: 2,
                                  margin: EdgeInsets.only(
                                      bottom: 8, left: 8, right: 8),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EpisodeDetailPage(
                                            animeId: anime.malId,
                                            episodeId: episode.malId,
                                          ),
                                        ),
                                      );
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blueAccent,
                                      child: Text(
                                        '${episode.malId}',
                                        style: TextStyle(color: const Color.fromARGB(255, 101, 101, 101)),
                                      ),
                                    ),
                                    title: Text(
                                      episode.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              Row(
                                                children: [
                                                  Icon(Icons.star,
                                                      size: 16,
                                                      color: Colors.amber),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    episode.score
                                                        .toStringAsFixed(2),
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            SizedBox(width: 10),
                                            if (episode.filler)
                                              _buildTag(
                                                  'Filler', Colors.orange),
                                            if (episode.recap)
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 6),
                                                child: _buildTag(
                                                    'Recap', Colors.blue),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: Icon(Icons.chevron_right,
                                        color: Colors.blueAccent),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: secondaryBlue, width: 4)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: secondaryBlue,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: secondaryBlue),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }
}
