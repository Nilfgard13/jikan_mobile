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
      appBar: AppBar(
        title: Text('Filter List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _fetchSchedule(_days[_selectedIndex]),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _days.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    selected: _selectedIndex == index,
                    label: Text(
                      _days[index].toUpperCase(),
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedIndex = index;
                      });
                      _fetchSchedule(_days[index]);
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.grey[200],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: $error'),
                            ElevatedButton(
                              onPressed: () =>
                                  _fetchSchedule(_days[_selectedIndex]),
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _fetchSchedule(_days[_selectedIndex]),
                        child: animeSchedules.isEmpty
                            ? Center(
                                child: Text(
                                    'No anime scheduled for ${_days[_selectedIndex]}'),
                              )
                            : ListView.builder(
                                itemCount: animeSchedules.length,
                                itemBuilder: (context, index) {
                                  final anime = animeSchedules[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.network(
                                          anime.imageUrl,
                                          width: 50,
                                          height: 75,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.error),
                                        ),
                                      ),
                                      title: Text(
                                        anime.title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Day: ${anime.day}'),
                                          Text('Score: ${anime.score}'),
                                          Text(
                                            anime.synopsis,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AnimeDetailPage(
                                                    malId: anime.malId),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
          ),
        ],
      ),
    );
  }
}
