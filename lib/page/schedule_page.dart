import 'package:flutter/material.dart';
import 'package:jikan/service/Anime_Service.dart';
import 'package:jikan/model/Schedule.dart';
import 'detail_page.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final AnimeService _apiService = AnimeService();
  List<AnimeSchedule> animeSchedules = [];
  bool isLoading = true;
  String? error;
  int _selectedIndex = 0;

  final List<String> _days = [
    'all',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
    'unknown',
    'other'
  ];

  @override
  void initState() {
    super.initState();
    _fetchSchedule(_days[_selectedIndex]);
  }

  Future<void> _fetchSchedule(String day) async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final schedules =
          await _apiService.getAnimeSchedule(filter: day == 'all' ? null : day);

      setState(() {
        animeSchedules = schedules;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 51, 51, 51),
      body: Container(
        child: Column(
          children: [
            // Safe area for status bar
            SizedBox(height: MediaQuery.of(context).padding.top),

            // Custom Filter Chips
            Container(
              height: 60,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: AnimatedScale(
                      scale: _selectedIndex == index ? 1.1 : 1.0,
                      duration: Duration(milliseconds: 200),
                      child: FilterChip(
                        selected: _selectedIndex == index,
                        label: Text(
                          _days[index].toUpperCase(),
                          style: TextStyle(
                            color: _selectedIndex == index
                                ? Colors.white
                                : Colors.grey[300],
                            fontWeight: _selectedIndex == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedIndex = index;
                          });
                          _fetchSchedule(_days[index]);
                        },
                        selectedColor:
                            Theme.of(context).primaryColor.withOpacity(0.8),
                        backgroundColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: _selectedIndex == index ? 4 : 0,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Content Area
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : error != null
                      ? _buildErrorWidget()
                      : RefreshIndicator(
                          onRefresh: () =>
                              _fetchSchedule(_days[_selectedIndex]),
                          child: animeSchedules.isEmpty
                              ? _buildEmptyState()
                              : _buildAnimeList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red[300],
          ),
          SizedBox(height: 16),
          Text(
            'Error: $error',
            style: TextStyle(color: Colors.grey[300]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _fetchSchedule(_days[_selectedIndex]),
            icon: Icon(Icons.refresh),
            label: Text('Retry'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 48,
            color: Colors.grey[600],
          ),
          SizedBox(height: 16),
          Text(
            'No anime scheduled for\n${_days[_selectedIndex].toUpperCase()}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimeList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: animeSchedules.length,
      itemBuilder: (context, index) {
        final anime = animeSchedules[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.only(bottom: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimeDetailPage(malId: anime.malId),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey[900]!.withOpacity(0.9),
                      Colors.grey[850]!.withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Anime Image
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: Hero(
                        tag: 'anime-${anime.malId}',
                        child: Image.network(
                          anime.imageUrl,
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 100,
                            height: 150,
                            color: Colors.grey[800],
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Anime Details
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              anime.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(width: 4),
                                Text(
                                  anime.day,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                SizedBox(width: 16),
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  anime.score.toString(),
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              anime.synopsis,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
