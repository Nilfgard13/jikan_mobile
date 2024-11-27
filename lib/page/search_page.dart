import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jikan/model/anime.dart';
import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Anime> _searchResults = [];
  bool _isLoading = false;
  String _error = '';

  Future<void> _searchAnime(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.jikan.moe/v4/anime?q=$query'),
      );

      if (response.statusCode == 200) {
        final List body = json.decode(response.body)['data'];
        setState(() {
          _searchResults = body.map((item) => Anime.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load search results';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(child: Text(_error, style: TextStyle(color: Colors.red)));
    }

    if (_searchResults.isEmpty) {
      return Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final anime = _searchResults[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                anime.imageUrl,
                width: 50,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 75,
                    color: Colors.grey[300],
                    child: Icon(Icons.error),
                  );
                },
              ),
            ),
            title: Text(anime.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  anime.synopsis,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    SizedBox(width: 4),
                    Text(anime.score.toString()),
                    SizedBox(width: 16),
                    Text('${anime.episodes} episodes'),
                  ],
                ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search anime...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onSubmitted: _searchAnime,
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Main app with bottom navigation
class AnimeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CurvedNavBar(
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
          Scaffold(
            appBar: AppBar(
              title: Text('Anime List'),
            ),
            body: Center(
              child: Text('Home Page', style: TextStyle(fontSize: 24)),
            ),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text('Schedule'),
            ),
            body: Center(
              child: Text('Schedule Page', style: TextStyle(fontSize: 24)),
            ),
          ),
        ],
        actionBarView:
            SearchPage(), // Use the SearchPage as the action bar view
      ),
    );
  }
}
