import 'package:flutter/material.dart';
import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:jikan/model/Anime.dart';
import 'package:jikan/model/Recommendation.dart';
import 'package:jikan/service/Anime_Service.dart';
import 'detail_page.dart';
import 'search_page.dart';
import 'schedule_page.dart';

class AnimeListPage extends StatefulWidget {
  @override
  _AnimeListPageState createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  late Future<List<Anime>> futureAnimeList;
  late Future<List<AnimeRecommendation>> futureRecommendations;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureAnimeList = AnimeService.fetchAnimeList();
    futureRecommendations = AnimeService.fetchRecommendations();
  }

  Widget _buildRecommendationsList() {
    return FutureBuilder<List<AnimeRecommendation>>(
      future: futureRecommendations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return SizedBox(height: 0);
        }

        return Container(
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.5),
                        Colors.blue.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.recommend,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Recommended Anime',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: snapshot.data!.length,
                  controller: PageController(viewportFraction: 0.85),
                  itemBuilder: (context, index) {
                    final recommendation = snapshot.data![index];
                    if (recommendation.entries.isEmpty) return const SizedBox();

                    final anime = recommendation.entries[0];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AnimeDetailPage(malId: anime.malId),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                anime.images.jpg.largeImageUrl,
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title
                                    Text(
                                      anime.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                        height: 1.2,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black87,
                                            offset: Offset(0, 2),
                                            blurRadius: 4,
                                          ),
                                          Shadow(
                                            color: Colors.black54,
                                            offset: Offset(0, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      recommendation.content,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 0.5,
                                        height: 1.3,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            offset: Offset(0, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimeList() {
    return FutureBuilder<List<Anime>>(
      future: futureAnimeList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No anime found'));
        }

        final animeList = snapshot.data!;
        return SingleChildScrollView(
          child: Container(
            color: const Color.fromARGB(255, 51, 51, 51),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRecommendationsList(),

                // Header Section
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Recent Anime',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 97, 97, 97),
                    ),
                  ),
                ),

                // Grid Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: animeList.length,
                      itemBuilder: (context, index) {
                        final anime = animeList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnimeDetailPage(
                                  malId: anime.malId,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFF424242), // Dark gray background
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blue
                                    .withOpacity(0.6), // Blue outline
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image Section
                                Expanded(
                                  flex: 5,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                    child: Image.network(
                                      anime.imageUrl,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[800],
                                          child: const Center(
                                            child: Icon(
                                              Icons.error_outline,
                                              color: Colors.white54,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                // Content Section
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Title
                                        Text(
                                          anime.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                            color: Colors
                                                .white, // White text for contrast
                                          ),
                                        ),

                                        // Score
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              color: Colors.amber,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              anime.score.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255,
                                                    114,
                                                    114,
                                                    114), // Light gray text
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Bottom Padding
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavBar(
      actionButton: CurvedActionBar(
        onTab: (value) {
          print(value);
        },
        activeIcon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 41, 41, 41),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.search,
            size: 50,
            color: Colors.blue,
          ),
        ),
        inActiveIcon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 41, 41, 41),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.search_outlined,
            size: 50,
            color: Colors.blue,
          ),
        ),
        text: "Search",
      ),
      activeColor: Colors.blue,
      navBarBackgroundColor: const Color.fromARGB(255, 41, 41, 41),
      inActiveColor: const Color.fromARGB(210, 97, 96, 96),
      appBarItems: [
        FABBottomAppBarItem(
          activeIcon: Icon(
            Icons.home,
            color: Colors.blue,
          ),
          inActiveIcon: Icon(
            Icons.home_outlined,
            color: const Color.fromARGB(210, 97, 96, 96),
          ),
          text: 'Home',
        ),
        FABBottomAppBarItem(
          activeIcon: Icon(
            Icons.calendar_today,
            color: Colors.blue,
          ),
          inActiveIcon: Icon(
            Icons.calendar_today_outlined,
            color: const Color.fromARGB(210, 71, 71, 71),
          ),
          text: 'Schedule',
        ),
      ],
      bodyItems: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.blue.withOpacity(0.8),
                width: 2.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color.fromARGB(255, 51, 51, 51),
              title: Row(
                children: [
                  Icon(
                    Icons.catching_pokemon,
                    color: Colors.blue,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Anime List',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Colors.blue,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.account_circle,
                        color: Colors.blue,
                        size: 34,
                      ),
                      onPressed: () {
                        // Add your user profile navigation logic here
                      },
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.0),
                        Colors.blue.withOpacity(0.5),
                        Colors.blue.withOpacity(0.0),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  height: 2,
                ),
              ),
            ),
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromARGB(255, 51, 51, 51),
                        const Color.fromARGB(255, 45, 45, 45),
                      ],
                    ),
                  ),
                ),
                _buildAnimeList(),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.0),
                          Colors.blue.withOpacity(0.7),
                          Colors.blue.withOpacity(0.0),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 51, 51, 51),
              title: Row(
                children: [
                  Icon(
                    Icons.catching_pokemon,
                    color: Colors.blue,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Anime Schedules',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Colors.blue,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      color: Colors.blue,
                      size: 34,
                    ),
                    onPressed: () {
                      // Add your user profile navigation logic here
                    },
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.0),
                        Colors.blue.withOpacity(0.5),
                        Colors.blue.withOpacity(0.0),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  height: 2,
                ),
              ),
            ),
            body: Center(
              child: ScheduleScreen(),
            ),
          ),
        ),
      ],
      actionBarView: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 51, 51, 51),
            title: Row(
              children: [
                Icon(
                  Icons.catching_pokemon,
                  color: Colors.blue,
                  size: 28,
                ),
                SizedBox(width: 12),
                Text(
                  'Anime Search',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.blue,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.blue,
                    size: 34,
                  ),
                  onPressed: () {
                    // Add your user profile navigation logic here
                  },
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.0),
                      Colors.blue.withOpacity(0.5),
                      Colors.blue.withOpacity(0.0),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                height: 2,
              ),
            ),
          ),
          body: Center(
            child: SearchPage(),
          ),
        ),
      ),
    );
  }
}
