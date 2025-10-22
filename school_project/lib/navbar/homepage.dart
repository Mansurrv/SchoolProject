import 'package:flutter/material.dart';
import 'package:school_project/navbar/news_screen.dart';
import 'package:school_project/navbar/profilepage.dart';
import 'package:school_project/navbar/searchpage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
                  MaterialPageRoute(builder: (context) => HomePage()),
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
                  MaterialPageRoute(builder: (context) => NewCatalogScreen()),
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
// Видеокурсы
class VideoCoursesPage extends StatefulWidget {
  const VideoCoursesPage({super.key});

  @override
  _VideoCoursesPageState createState() => _VideoCoursesPageState();
}

class _VideoCoursesPageState extends State<VideoCoursesPage> {
  late YoutubePlayerController _controller;
  String _currentVideoId = '';
  String _currentVideoTitle = '';

  late Future<Map<String, List<Map<String, String>>>> _videoCategoriesFuture;

  @override
  void initState() {
    super.initState();
    _videoCategoriesFuture = _fetchVideoCategories();
  }

  Future<Map<String, List<Map<String, String>>>> _fetchVideoCategories() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/videos'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      Map<String, List<Map<String, String>>> categories = {};

      for (var video in data) {
        String category = video['category'] ?? 'Без категории';
        if (!categories.containsKey(category)) {
          categories[category] = [];
        }
        categories[category]!.add({
          'title': video['title'] ?? '',
          'url': video['url'] ?? '',
          'description': video['description'] ?? '',
        });
      }

      // Инициализация первого видео
      if (categories.isNotEmpty) {
        final firstCategory = categories.values.first;
        if (firstCategory.isNotEmpty) {
          final firstVideo = firstCategory.first;
          _currentVideoId = YoutubePlayer.convertUrlToId(firstVideo['url']!)!;
          _currentVideoTitle = firstVideo['title']!;
          _controller = YoutubePlayerController(
            initialVideoId: _currentVideoId,
            flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
          );
        }
      }

      return categories;
    } else {
      throw Exception('Ошибка загрузки видеокурсов');
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
    return FutureBuilder<Map<String, List<Map<String, String>>>>(
      future: _videoCategoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Видеокурсы')),
            body: Center(child: Text('Ошибка: ${snapshot.error}')),
          );
        }

        final videoCategories = snapshot.data!;
        if (videoCategories.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('Видеокурсы не найдены')),
          );
        }

        return DefaultTabController(
          length: videoCategories.keys.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Видеокурсы'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminVideoPage()),
                    );
                  },
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                tabs: videoCategories.keys
                    .map((category) => Tab(text: category))
                    .toList(),
              ),
            ),
            body: Column(
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Expanded(
                  child: TabBarView(
                    children: videoCategories.keys.map((category) {
                      final videos = videoCategories[category]!;
                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          final video = videos[index];
                          return Card(
                            color: const Color.fromRGBO(236, 178, 65, 1),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              title: Text(
                                video['title']!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  video['description'] ?? '',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 13),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.play_circle_fill,
                                    color: Colors.white, size: 35),
                                onPressed: () =>
                                    _playVideo(video['url']!, video['title']!),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

class AdminVideoPage extends StatefulWidget {
  const AdminVideoPage({super.key});

  @override
  State<AdminVideoPage> createState() => _AdminVideoPageState();
}

class _AdminVideoPageState extends State<AdminVideoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  bool _isLoading = false;
  String _message = '';

  Future<void> _addVideo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final url = Uri.parse("http://127.0.0.1:8000/videos");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": _titleController.text.trim(),
          "description": _descriptionController.text.trim(),
          "category": _categoryController.text.trim(),
          "url": _urlController.text.trim(),
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        setState(() {
          _message = "✅ Видео успешно добавлено!";
        });
        _formKey.currentState!.reset();
      } else {
        setState(() {
          _message = "❌ Ошибка при добавлении видео: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _message = "⚠️ Ошибка соединения: $e";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Админка — Добавить видео"),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Название видео"),
                validator: (value) =>
                    value!.isEmpty ? "Введите название" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Описание"),
                validator: (value) =>
                    value!.isEmpty ? "Введите описание" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Категория"),
                validator: (value) =>
                    value!.isEmpty ? "Введите категорию" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _urlController,
                decoration:
                    const InputDecoration(labelText: "Ссылка на YouTube"),
                validator: (value) =>
                    value!.isEmpty ? "Введите ссылку" : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(236, 178, 65, 1),
                        padding: const EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _addVideo,
                      child: const Text(
                        "Добавить видео",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
              const SizedBox(height: 12),
              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains("✅")
                        ? Colors.green
                        : Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
