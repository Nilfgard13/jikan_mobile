import 'package:flutter/material.dart';
import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:jikan/model/Anime.dart';
import 'package:jikan/service/Anime_Service.dart';
import 'detail_page.dart';
import 'search_page.dart';
import 'schedule_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimeListPage(),
    );
  }
}

class AnimeListPage extends StatefulWidget {
  @override
  _AnimeListPageState createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  late Future<List<Anime>> futureAnimeList;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureAnimeList = AnimeService.fetchAnimeList();
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
            color: Colors.white,
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
            color: Colors.white70,
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
      navBarBackgroundColor: Colors.white,
      inActiveColor: Colors.black45,
      appBarItems: [
        FABBottomAppBarItem(
          activeIcon: Icon(
            Icons.home,
            color: Colors.blue,
          ),
          inActiveIcon: Icon(
            Icons.home_outlined,
            color: Colors.black26,
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
            color: Colors.black26,
          ),
          text: 'Schedule',
        ),
      ],
      bodyItems: [
        // Home page with anime list
        Scaffold(
          appBar: AppBar(
            title: Text('Anime List'),
          ),
          body: _buildAnimeList(),
        ),
        // Favorites page
        Scaffold(
          appBar: AppBar(
            title: Text('Favorites'),
          ),
          body: Center(
            child: ScheduleScreen(),
          ),
        ),
      ],
      actionBarView: Scaffold(
        appBar: AppBar(
          title: Text('Add Anime'),
        ),
        body: Center(
          child: SearchPage(),
        ),
      ),
    );
  }
}
