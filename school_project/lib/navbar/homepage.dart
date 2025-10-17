import 'package:flutter/material.dart';
import 'package:school_project/navbar/news_screen.dart';
import 'package:school_project/navbar/profilepage.dart';
import 'package:school_project/navbar/searchpage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> _items = [
    {'title': 'Видеокурсы', 'icon': Icons.video_library, 'route': VideoCoursesPage()},
    {'title': 'Игры', 'icon': Icons.games, 'route': GamesPage()},
    {'title': 'Рисование', 'icon': Icons.brush, 'route': DrawingPage()},
    {'title': 'Тренировка для учеников', 'icon': Icons.fitness_center, 'route': TrainingPage()},
    {'title': 'Влог от медиков', 'icon': Icons.local_hospital, 'route': MedicalVlogPage()},
    {'title': 'Афиша', 'icon': Icons.event, 'route': EventsPage()},
    {'title': 'Макалалар', 'icon': Icons.article, 'route': ArticlesPage()},
    {'title': 'FAQ', 'icon': Icons.help, 'route': FAQPage()},
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная страница'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Количество столбцов
            crossAxisSpacing: 20, // Горизонтальный отступ
            mainAxisSpacing: 20, // Вертикальный отступ
            childAspectRatio: 0.8, // Пропорции ячейки (ширина:высота)
          ),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _items[index]['route'],
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(236, 178, 65, 1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      _items[index]['icon'],
                      size: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _items[index]['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                // Перехожу на экран CatalogScreens
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CatalogScreens()),
                );
              },
              icon: const Icon(Icons.apps_outlined),
              iconSize: 50,
              color: const Color.fromRGBO(0, 0, 0, 1),
            ),
            IconButton(
              onPressed: () {
                // Перехожу на экран NewCatalogScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
              icon: const Icon(Icons.search),
              iconSize: 50,
              color: const Color.fromRGBO(0, 0, 0, 1),
            ),
            IconButton(
              onPressed: () {
                // Перехожу на экран NewCatalogScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewCatalogScreen()),
                );
              },
              icon: const Icon(Icons.home),
              iconSize: 50,
              color: const Color.fromRGBO(0, 0, 0, 1),
            ),
            IconButton(
              onPressed: () {
                // Перехожу на экран NewCatalogScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              icon: const Icon(Icons.book),
              iconSize: 50,
              color: const Color.fromRGBO(0, 0, 0, 1),
            ),
            IconButton(
              onPressed: () {
                // Перехожу на экран NewCatalogScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              icon: const Icon(Icons.account_circle),
              iconSize: 40,
              color: const Color.fromRGBO(0, 0, 0, 1),
            ),
          ],
        ),
      ),
    );
  }
}

// Видеокурсы
class VideoCoursesPage extends StatefulWidget {
  const VideoCoursesPage({super.key});

  @override
  _VideoCoursesPageState createState() => _VideoCoursesPageState();
}

class Tutlist{
  String fio;
  String place;
  String date;
  String img;

  Tutlist(this.fio, this.place, this.date, this.img);
}

class _VideoCoursesPageState extends State<VideoCoursesPage> {
  final Map<String, List<Map<String, String>>> _videoCategories = {
    'Урок 1': [
      {'title': 'Әліппені үйренеміз.', 'url': 'https://www.youtube.com/watch?v=NnuKep4JJ-M',
      'description': 'В этом уроке мы познакомимся с основами алфавита.'},
    ],
    'Урок 2': [
      {'title': 'Видео 1', 'url': 'https://www.youtube.com/watch?v=kJQP7kiw5Fk'},
    ],
    'Урок 3': [
      {'title': 'Видео 1', 'url': 'https://www.youtube.com/watch?v=3JZ_D3ELwOQ'},
    ],
    'Урок 4': [
      {'title': 'Видео 1', 'url': 'https://www.youtube.com/watch?v=9bZkp7q19f0'},
    ],
    'Урок 5': [
      {'title': 'Видео 1', 'url': 'https://www.youtube.com/watch?v=fRh_vgS2dFE'},
    ],
    'Урок 6': [
      {'title': 'Видео 1', 'url': 'https://www.youtube.com/watch?v=RgKAFK5djSk'},
    ],
    'Урок 7': [
      {'title': 'Видео 1', 'url': 'https://www.youtube.com/watch?v=3tmd-ClpJxA'},
    ],
  };

  late YoutubePlayerController _controller;
  String _currentVideoId = '';
  String _currentVideoTitle = '';



  @override
  void initState() {
    super.initState();
    _initializeController();
  }
  void _initializeController() {
    final firstCategory = _videoCategories.values.first;
    if (firstCategory.isNotEmpty) {
      final firstVideo = firstCategory.first;
      _currentVideoId = YoutubePlayer.convertUrlToId(firstVideo['url']!)!;
      _currentVideoTitle = firstVideo['title']!;
      _controller = YoutubePlayerController(
        initialVideoId: _currentVideoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  void _playVideo(String videoUrl, String title) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId != null) {
      setState(() {
        _currentVideoId = videoId;
        _currentVideoTitle = title;
        _controller.load(_currentVideoId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _videoCategories.keys.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Видеокурсы'),
          bottom: TabBar(
            isScrollable: true,
            tabs: _videoCategories.keys
                .map((category) => Tab(text: category))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: _videoCategories.keys.map((category) {
            return ListView(
              children: _videoCategories[category]!.map((video) {
                return ListTile(
                  title: Text(video['title']!),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () => _playVideo(video['url']!, video['title']!),
                );
              }).toList(),
            );
          }).toList(),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_currentVideoId.isNotEmpty)
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
              ),
            if (_currentVideoTitle.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _currentVideoTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}


// Игры

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Игры')),
      body: const Center(child: Text('Страница игр')),
    );
  }
}

// Рисование

class DrawingPage extends StatelessWidget {
  const DrawingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Рисование')),
      body: const Center(child: Text('Страница рисования')),
    );
  }
}

// Физическая подготовка

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Тренировка для учеников')),
      body: const Center(child: Text('Страница тренировки')),
    );
    
  }
}

class MedicalVlogPage extends StatelessWidget {
  const MedicalVlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Влог от медиков')),
      body: const Center(child: Text('Страница медицинского влога')),
    );
  }
}

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Афиша')),
      body: const Center(child: Text('Страница афиши')),
    );
  }
}

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Макалалар')),
      body: const Center(child: Text('Страница макалалар')),
    );
  }
}

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: const Center(child: Text('Страница FAQ')),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
