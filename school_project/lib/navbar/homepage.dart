import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_project/navbar/news_screen.dart';
import 'package:school_project/navbar/profilepage.dart';
import 'package:school_project/navbar/searchpage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> _items = [
    {'title': 'Видеокурсы', 'icon': Icons.video_library, 'route': VideoCoursesPage()},
    // {'title': 'Игры', 'icon': Icons.games, 'route': GamesPage()},
    {'title': 'Рисование', 'icon': Icons.brush, 'route': DrawingPage()},
    {'title': 'Тренировка для учеников', 'icon': Icons.fitness_center, 'route': TrainingPage()},
    {'title': 'Влог от медиков', 'icon': Icons.local_hospital, 'route': MedicalVlogPage()},
    {'title': 'FAQ', 'icon': Icons.help, 'route': FAQPage()},
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная страница'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.8,
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
      // Updated Bottom Navigation Bar to match News Screen
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(23, 21, 21, 1),
          border: Border(
            top: BorderSide(
              color: Colors.grey[800]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navButton(context, Icons.apps_outlined, 45, CatalogScreens()),
            _navButton(context, Icons.search, 45, SearchPage()),
            _navButton(context, Icons.home, 45, HomePage()),
            _navButton(context, Icons.library_books, 45, LibraryPage()),
            _navButton(context, Icons.account_circle, 35, ProfilePage()),
          ],
        ),
      ),
    );
  }

  Widget _navButton(BuildContext context, IconData icon, double size, Widget page) {
    return IconButton(
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      icon: Icon(icon),
      iconSize: size,
      color: const Color.fromRGBO(236, 178, 65, 1),
    );
  }
}

// Library Page for Reading Books
// Library Page for Reading Books
class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late Future<List<Book>> _booksFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Book> _filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _booksFuture = _fetchBooks();
  }

  Future<List<Book>> _fetchBooks() async {
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      Book(
        id: '1',
        title: 'Война и мир',
        author: 'Лев Толстой',
        description: 'Роман-эпопея, описывающий русское общество в эпоху войн против Наполеона.',
        coverUrl: 'https://via.placeholder.com/150x200',
        category: 'Классика',
        pages: 1225,
      ),
      Book(
        id: '2',
        title: 'Преступление и наказание',
        author: 'Фёдор Достоевский',
        description: 'Психологический роман о студенте, совершившем убийство.',
        coverUrl: 'https://via.placeholder.com/150x200',
        category: 'Классика',
        pages: 551,
      ),
      Book(
        id: '3',
        title: 'Мастер и Маргарита',
        author: 'Михаил Булгаков',
        description: 'Мистический роман о визите дьявола в Москву 1930-х годов.',
        coverUrl: 'https://via.placeholder.com/150x200',
        category: 'Фантастика',
        pages: 480,
      ),
      Book(
        id: '4',
        title: 'Евгений Онегин',
        author: 'Александр Пушкин',
        description: 'Роман в стихах, одно из самых значительных произведений русской литературы.',
        coverUrl: 'https://via.placeholder.com/150x200',
        category: 'Поэзия',
        pages: 240,
      ),
    ];
  }

  void _filterBooks(String query) {
    if (query.isEmpty) {
      _booksFuture.then((books) {
        setState(() {
          _filteredBooks = books;
        });
      });
    } else {
      _booksFuture.then((books) {
        setState(() {
          _filteredBooks = books.where((book) =>
            book.title.toLowerCase().contains(query.toLowerCase()) ||
            book.author.toLowerCase().contains(query.toLowerCase()) ||
            book.category.toLowerCase().contains(query.toLowerCase())
          ).toList();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Библиотека'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // This removes the back button
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBookPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterBooks,
              decoration: InputDecoration(
                hintText: 'Поиск книг...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _booksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                }

                final books = _searchController.text.isEmpty 
                  ? snapshot.data! 
                  : _filteredBooks;

                if (books.isEmpty) {
                  return const Center(child: Text('Книги не найдены'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 60,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                            image: DecorationImage(
                              image: NetworkImage(book.coverUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          book.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Автор: ${book.author}'),
                            Text('Категория: ${book.category}'),
                            Text('Страниц: ${book.pages}'),
                            const SizedBox(height: 8),
                            Text(
                              book.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.menu_book, color: Color.fromRGBO(236, 178, 65, 1)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookReaderPage(book: book),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Add the same bottom navigation bar as HomePage and News Screen
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(23, 21, 21, 1),
          border: Border(
            top: BorderSide(
              color: Colors.grey[800]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navButton(context, Icons.apps_outlined, 45, CatalogScreens()),
            _navButton(context, Icons.search, 45, SearchPage()),
            _navButton(context, Icons.home, 45, HomePage()),
            _navButton(context, Icons.library_books, 45, LibraryPage()),
            _navButton(context, Icons.account_circle, 35, ProfilePage()),
          ],
        ),
      ),
    );
  }

  Widget _navButton(BuildContext context, IconData icon, double size, Widget page) {
    return IconButton(
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      icon: Icon(icon),
      iconSize: size,
      color: const Color.fromRGBO(236, 178, 65, 1),
    );
  }
}

// Book Model
class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final String category;
  final int pages;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.category,
    required this.pages,
  });
}

// Book Reader Page
class BookReaderPage extends StatefulWidget {
  final Book book;

  const BookReaderPage({super.key, required this.book});

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<String> _bookPages = [
    "Глава 1\n\nЭто первая страница книги. Здесь начинается увлекательное повествование...",
    "Глава 1 (продолжение)\n\nГерой произведения оказывается в сложной ситуации...",
    "Глава 2\n\nНовые персонажи входят в историю, привнося свои характеры и мотивы...",
    "Глава 3\n\nСюжет развивается, раскрывая глубину замысла автора...",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white, // White back button
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentPage + 1) / _bookPages.length,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Color.fromRGBO(236, 178, 65, 1)),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _bookPages.length,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Text(
                      _bookPages[index],
                      style: const TextStyle(fontSize: 18, height: 1.6),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Страница ${_currentPage + 1} из ${_bookPages.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _currentPage > 0 ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _currentPage < _bookPages.length - 1 ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Add Book Page (Admin functionality)
class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _pagesController = TextEditingController();
  final TextEditingController _coverUrlController = TextEditingController();

  bool _isLoading = false;
  String _message = '';

  Future<void> _addBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _message = "✅ Книга успешно добавлена!";
      });
      _formKey.currentState!.reset();
    } catch (e) {
      setState(() {
        _message = "⚠️ Ошибка при добавлении книги: $e";
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
        title: const Text("Добавить книгу"),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white, // White back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Название книги"),
                validator: (value) =>
                    value!.isEmpty ? "Введите название" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: "Автор"),
                validator: (value) =>
                    value!.isEmpty ? "Введите автора" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Описание"),
                maxLines: 3,
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
                controller: _pagesController,
                decoration: const InputDecoration(labelText: "Количество страниц"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Введите количество страниц" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _coverUrlController,
                decoration: const InputDecoration(labelText: "Ссылка на обложку"),
                validator: (value) =>
                    value!.isEmpty ? "Введите ссылку на обложку" : null,
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
                      onPressed: _addBook,
                      child: const Text(
                        "Добавить книгу",
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

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рисование'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        selectedItemColor: const Color.fromRGBO(236, 178, 65, 1),
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Уроки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Видео',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.brush),
            label: 'Техники',
          ),
        ],
      ),
    );
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const DrawingLessonsPage();
      case 1:
        return const VideoTutorialsPage();
      case 2:
        return const TechniquesPage();
      default:
        return const DrawingLessonsPage();
    }
  }
}

// Drawing Lessons Page
class DrawingLessonsPage extends StatelessWidget {
  const DrawingLessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildLessonCard(
          context,
          'Основы рисования',
          'Начните с основ: линии, формы, перспектива',
          Icons.architecture,
          const BasicDrawingLesson(),
        ),
        _buildLessonCard(
          context,
          'Рисование портрета',
          'Учимся рисовать лица и выражения',
          Icons.face,
          const PortraitDrawingLesson(),
        ),
        _buildLessonCard(
          context,
          'Пейзажи',
          'Рисование природы и городских пейзажей',
          Icons.landscape,
          const LandscapeDrawingLesson(),
        ),
        _buildLessonCard(
          context,
          'Акварельная техника',
          'Освоение работы с акварельными красками',
          Icons.color_lens,
          const WatercolorLesson(),
        ),
        _buildLessonCard(
          context,
          'Рисование животных',
          'Изображаем животных и птиц',
          Icons.pets,
          const AnimalsDrawingLesson(),
        ),
        _buildLessonCard(
          context,
          'Композиция и цвет',
          'Основы композиции и цветовой гармонии',
          Icons.palette,
          const CompositionLesson(),
        ),
      ],
    );
  }

  Widget _buildLessonCard(BuildContext context, String title, String description, IconData icon, Widget page) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 40, color: const Color.fromRGBO(236, 178, 65, 1)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}

// Basic Drawing Lesson
class BasicDrawingLesson extends StatelessWidget {
  const BasicDrawingLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Основы рисования'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStep(
            'Шаг 1: Линии и штриховка',
            'Начните с простых линий. Практикуйте прямые, кривые и волнистые линии. '
                'Освойте разные виды штриховки: параллельная, перекрестная, круговая.',
            'assets/drawing/step1.jpg', // Replace with your image path
          ),
          _buildStep(
            'Шаг 2: Геометрические формы',
            'Учитесь рисовать основные геометрические формы: круг, квадрат, треугольник. '
                'Это основа для любых сложных объектов.',
            'assets/drawing/step2.jpg',
          ),
          _buildStep(
            'Шаг 3: Объем и светотень',
            'Добавляйте объем с помощью светотени. Определите источник света и '
                'работайте с тонами: свет, полутень, тень, рефлекс.',
            'assets/drawing/step3.jpg',
          ),
          _buildStep(
            'Шаг 4: Перспектива',
            'Освойте линейную перспективу. Точка схода поможет создавать '
                'реалистичные пространственные композиции.',
            'assets/drawing/step4.jpg',
          ),
          _buildExerciseSection(),
        ],
      ),
    );
  }

  Widget _buildStep(String title, String description, String imagePath) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/400x200'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Упражнения для практики', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildExerciseItem('Рисуйте 10 минут каждый день простые линии и формы'),
            _buildExerciseItem('Сделайте 10 набросков разных предметов в вашей комнате'),
            _buildExerciseItem('Практикуйте штриховку на разных поверхностях'),
            _buildExerciseItem('Рисуйте один предмет с разных точек зрения'),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

// Video Tutorials Page
class VideoTutorialsPage extends StatefulWidget {
  const VideoTutorialsPage({super.key});

  @override
  State<VideoTutorialsPage> createState() => _VideoTutorialsPageState();
}

class _VideoTutorialsPageState extends State<VideoTutorialsPage> {
  final List<Map<String, String>> _videoTutorials = [
    {
      'title': 'Основы акварели для начинающих',
      'videoId': 'dQw4w9WgXcQ', // Replace with actual YouTube video ID
      'duration': '15:30',
      'level': 'Начальный',
    },
    {
      'title': 'Рисование портрета карандашом',
      'videoId': 'dQw4w9WgXcQ',
      'duration': '25:45',
      'level': 'Средний',
    },
    {
      'title': 'Пейзаж масляными красками',
      'videoId': 'dQw4w9WgXcQ',
      'duration': '35:20',
      'level': 'Продвинутый',
    },
    {
      'title': 'Скетчинг маркерами',
      'videoId': 'dQw4w9WgXcQ',
      'duration': '18:15',
      'level': 'Начальный',
    },
    {
      'title': 'Анатомия для художников',
      'videoId': 'dQw4w9WgXcQ',
      'duration': '42:10',
      'level': 'Продвинутый',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _videoTutorials.length,
      itemBuilder: (context, index) {
        final tutorial = _videoTutorials[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
              ),
              child: Icon(Icons.play_circle_fill, size: 40, color: const Color.fromRGBO(236, 178, 65, 1)),
            ),
            title: Text(tutorial['title']!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Длительность: ${tutorial['duration']}'),
                Text('Уровень: ${tutorial['level']}'),
              ],
            ),
            trailing: const Icon(Icons.play_arrow),
            onTap: () {
              _playVideo(context, tutorial['videoId']!, tutorial['title']!);
            },
          ),
        );
      },
    );
  }

  void _playVideo(BuildContext context, String videoId, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(videoId: videoId, title: title),
      ),
    );
  }
}

// Video Player Page
class VideoPlayerPage extends StatefulWidget {
  final String videoId;
  final String title;

  const VideoPlayerPage({super.key, required this.videoId, required this.title});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'В этом уроке вы научитесь основам техники рисования. '
                    'Следуйте инструкциям шаг за шагом и практикуйтесь регулярно.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  _buildMaterialsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Необходимые материалы:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildMaterialItem('Бумага для рисования'),
            _buildMaterialItem('Карандаши разной твердости'),
            _buildMaterialItem('Ластик'),
            _buildMaterialItem('Точилка'),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialItem(String material) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Text(material),
        ],
      ),
    );
  }
}

// Techniques Page
class TechniquesPage extends StatelessWidget {
  const TechniquesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTechniqueCard(
          'Карандашная графика',
          'Техника работы с карандашом, штриховка, создание объема',
          Icons.edit,
          Colors.grey[700]!,
        ),
        _buildTechniqueCard(
          'Акварельная живопись',
          'Работа с водяными красками, лессировка, заливки',
          Icons.water_drop,
          Colors.blue[300]!,
        ),
        _buildTechniqueCard(
          'Масляная живопись',
          'Классическая техника работы с масляными красками',
          Icons.palette,
          Colors.orange[300]!,
        ),
        _buildTechniqueCard(
          'Пастель',
          'Работа с сухой и масляной пастелью',
          Icons.brush,
          Colors.pink[300]!,
        ),
        _buildTechniqueCard(
          'Скетчинг',
          'Быстрое рисование, создание эскизов',
          Icons.gesture,
          Colors.green[300]!,
        ),
        _buildTechniqueCard(
          'Графика тушью',
          'Работа с пером и тушью, создание контрастных изображений',
          Icons.architecture,
          Colors.black,
        ),
      ],
    );
  }

  Widget _buildTechniqueCard(String title, String description, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// Other lesson classes (you can expand these similarly to BasicDrawingLesson)
class PortraitDrawingLesson extends StatelessWidget {
  const PortraitDrawingLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рисование портрета'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Страница уроков по рисованию портрета'),
      ),
    );
  }
}

class LandscapeDrawingLesson extends StatelessWidget {
  const LandscapeDrawingLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пейзажи'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Страница уроков по рисованию пейзажей'),
      ),
    );
  }
}

class WatercolorLesson extends StatelessWidget {
  const WatercolorLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Акварельная техника'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Страница уроков по акварельной технике'),
      ),
    );
  }
}

class AnimalsDrawingLesson extends StatelessWidget {
  const AnimalsDrawingLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рисование животных'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Страница уроков по рисованию животных'),
      ),
    );
  }
}

class CompositionLesson extends StatelessWidget {
  const CompositionLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Композиция и цвет'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Страница уроков по композиции и цвету'),
      ),
    );
  }
}

// Физическая подготовка
class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тренировка для учеников'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        selectedItemColor: const Color.fromRGBO(236, 178, 65, 1),
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Программы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Упражнения',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Прогресс',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Расписание',
          ),
        ],
      ),
    );
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const TrainingProgramsPage();
      case 1:
        return const ExercisesPage();
      case 2:
        return const ProgressPage();
      case 3:
        return const SchedulePage();
      default:
        return const TrainingProgramsPage();
    }
  }
}

// Training Programs Page
class TrainingProgramsPage extends StatelessWidget {
  const TrainingProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProgramCard(
          context,
          'Начальный уровень',
          'Для тех, кто только начинает заниматься',
          '7 дней',
          'Легкая',
          Icons.flag,
          Colors.green,
          const BeginnerProgram(),
        ),
        _buildProgramCard(
          context,
          'Средний уровень',
          'Для продолжающих с базовой подготовкой',
          '14 дней',
          'Средняя',
          Icons.directions_run,
          Colors.orange,
          const IntermediateProgram(),
        ),
        _buildProgramCard(
          context,
          'Продвинутый уровень',
          'Для опытных с хорошей физической формой',
          '21 день',
          'Высокая',
          Icons.fitness_center,
          Colors.red,
          const AdvancedProgram(),
        ),
        _buildProgramCard(
          context,
          'Утренняя зарядка',
          'Быстрая зарядка для пробуждения',
          'Ежедневно',
          'Легкая',
          Icons.wb_sunny,
          Colors.blue,
          const MorningWorkout(),
        ),
        _buildProgramCard(
          context,
          'Растяжка и гибкость',
          'Упражнения для развития гибкости',
          '10 дней',
          'Легкая',
          Icons.self_improvement,
          Colors.purple,
          const FlexibilityProgram(),
        ),
      ],
    );
  }

  Widget _buildProgramCard(BuildContext context, String title, String description, 
      String duration, String intensity, IconData icon, Color color, Widget page) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildProgramInfo(Icons.schedule, duration),
                        const SizedBox(width: 12),
                        _buildProgramInfo(Icons.speed, intensity),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgramInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

// Beginner Training Program
class BeginnerProgram extends StatelessWidget {
  const BeginnerProgram({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Начальный уровень'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDayCard(
            'День 1: Основы',
            [
              'Разминка: 5 минут',
              'Приседания: 3 подхода по 10 раз',
              'Отжимания (с колен): 3 подхода по 8 раз',
              'Планка: 3 подхода по 20 секунд',
              'Заминка: 5 минут растяжки',
            ],
          ),
          _buildDayCard(
            'День 2: Кардио',
            [
              'Разминка: 5 минут',
              'Бег на месте: 3 подхода по 2 минуты',
              'Прыжки через скакалку: 3 подхода по 1 минуте',
              'Выпады: 3 подхода по 10 раз на каждую ногу',
              'Заминка: 5 минут растяжки',
            ],
          ),
          _buildDayCard(
            'День 3: Верх тела',
            [
              'Разминка: 5 минут',
              'Отжимания: 3 подхода по 10 раз',
              'Подтягивания (с резинкой): 3 подхода по 5 раз',
              'Подъемы рук с гантелями: 3 подхода по 12 раз',
              'Заминка: 5 минут растяжки',
            ],
          ),
          _buildStartButton(context),
        ],
      ),
    );
  }

  Widget _buildDayCard(String title, List<String> exercises) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...exercises.map((exercise) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(exercise)),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(236, 178, 65, 1),
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WorkoutSessionPage()),
        );
      },
      child: const Text(
        'Начать тренировку',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}

// Exercises Page
class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildExerciseCategory('Силовые упражнения', Icons.fitness_center, [
          _buildExerciseCard('Приседания', 'assets/exercises/squats.jpg', 'Ноги, ягодицы'),
          _buildExerciseCard('Отжимания', 'assets/exercises/pushups.jpg', 'Грудь, руки'),
          _buildExerciseCard('Планка', 'assets/exercises/plank.jpg', 'Пресс, кор'),
        ]),
        _buildExerciseCategory('Кардио упражнения', Icons.directions_run, [
          _buildExerciseCard('Бег на месте', 'assets/exercises/running.jpg', 'Кардио, ноги'),
          _buildExerciseCard('Прыжки', 'assets/exercises/jumps.jpg', 'Кардио, все тело'),
          _buildExerciseCard('Скакалка', 'assets/exercises/jumprope.jpg', 'Кардио, координация'),
        ]),
        _buildExerciseCategory('Растяжка', Icons.self_improvement, [
          _buildExerciseCard('Наклоны вперед', 'assets/exercises/forward_bend.jpg', 'Спина, ноги'),
          _buildExerciseCard('Бабочка', 'assets/exercises/butterfly.jpg', 'Бедра, пах'),
          _buildExerciseCard('Скручивания', 'assets/exercises/twist.jpg', 'Спина, пресс'),
        ]),
      ],
    );
  }

  Widget _buildExerciseCategory(String title, IconData icon, List<Widget> exercises) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color.fromRGBO(236, 178, 65, 1)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...exercises,
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(String title, String image, String muscles) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300],
            image: const DecorationImage(
              image: NetworkImage('https://via.placeholder.com/50'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(title),
        subtitle: Text(muscles),
        trailing: const Icon(Icons.play_arrow, color: Color.fromRGBO(236, 178, 65, 1)),
        onTap: () {
          // Navigate to exercise detail
        },
      ),
    );
  }
}

// Progress Tracking Page
class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _completedWorkouts = 12;
  int _totalMinutes = 180;
  int _currentStreak = 5;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats Cards
        Row(
          children: [
            Expanded(child: _buildStatCard('Завершено тренировок', _completedWorkouts.toString(), Icons.check_circle)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Минут тренировок', _totalMinutes.toString(), Icons.timer)),
          ],
        ),
        const SizedBox(height: 12),
        _buildStatCard('Текущая серия', '$_currentStreak дней', Icons.local_fire_department),
        
        const SizedBox(height: 24),
        const Text(
          'Последние тренировки',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildWorkoutHistoryItem('Утренняя зарядка', '15 мин', 'Сегодня'),
        _buildWorkoutHistoryItem('Силовая тренировка', '45 мин', 'Вчера'),
        _buildWorkoutHistoryItem('Растяжка', '20 мин', '2 дня назад'),
        _buildWorkoutHistoryItem('Кардио', '30 мин', '3 дня назад'),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: const Color.fromRGBO(236, 178, 65, 1)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutHistoryItem(String workout, String duration, String date) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.fitness_center, color: Colors.green),
        title: Text(workout),
        subtitle: Text(duration),
        trailing: Text(
          date,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}

// Schedule Page
class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildScheduleDay('Понедельник', 'Силовая тренировка', '30 минут'),
        _buildScheduleDay('Вторник', 'Кардио', '25 минут'),
        _buildScheduleDay('Среда', 'Растяжка', '20 минут'),
        _buildScheduleDay('Четверг', 'Силовая тренировка', '30 минут'),
        _buildScheduleDay('Пятница', 'Кардио', '25 минут'),
        _buildScheduleDay('Суббота', 'Активный отдых', '40 минут'),
        _buildScheduleDay('Воскресенье', 'Отдых', '-'),
        
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Рекомендации',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildRecommendation('Пейте воду до, во время и после тренировки'),
                _buildRecommendation('Не забывайте про разминку и заминку'),
                _buildRecommendation('Слушайте свое тело - не перенапрягайтесь'),
                _buildRecommendation('Регулярность важнее интенсивности'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleDay(String day, String workout, String duration) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(236, 178, 65, 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            workout == 'Отдых' ? Icons.hotel : Icons.fitness_center,
            color: const Color.fromRGBO(236, 178, 65, 1),
          ),
        ),
        title: Text(day),
        subtitle: Text(workout),
        trailing: Text(
          duration,
          style: TextStyle(
            color: workout == 'Отдых' ? Colors.grey : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendation(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

// Workout Session Page (Live workout)
class WorkoutSessionPage extends StatefulWidget {
  const WorkoutSessionPage({super.key});

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage> {
  int _currentExercise = 0;
  int _secondsRemaining = 60;
  bool _isRunning = false;

  final List<Map<String, dynamic>> _workoutExercises = [
    {
      'name': 'Разминка',
      'duration': 300, // 5 minutes
      'description': 'Подготовьте мышцы к тренировке'
    },
    {
      'name': 'Приседания',
      'duration': 180, // 3 minutes
      'description': '3 подхода по 10 повторений'
    },
    {
      'name': 'Отжимания',
      'duration': 180,
      'description': '3 подхода по 8 повторений'
    },
    {
      'name': 'Планка',
      'duration': 180,
      'description': '3 подхода по 20 секунд'
    },
    {
      'name': 'Заминка',
      'duration': 300,
      'description': 'Растяжка основных групп мышц'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentEx = _workoutExercises[_currentExercise];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тренировка'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Progress
          LinearProgressIndicator(
            value: (_currentExercise + 1) / _workoutExercises.length,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Color.fromRGBO(236, 178, 65, 1)),
          ),
          // Exercise Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentEx['name'],
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentEx['description'],
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Timer
                  Text(
                    '${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _isRunning ? _pauseTimer : _startTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(236, 178, 65, 1),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: Text(
                          _isRunning ? 'Пауза' : 'Старт',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _nextExercise,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: const Text('Далее', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    // Timer logic would go here
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
  }

  void _nextExercise() {
    setState(() {
      if (_currentExercise < _workoutExercises.length - 1) {
        _currentExercise++;
        _secondsRemaining = _workoutExercises[_currentExercise]['duration'];
      } else {
        // Workout completed
        Navigator.pop(context);
      }
    });
  }
}

// Other program classes (simplified)
class IntermediateProgram extends StatelessWidget {
  const IntermediateProgram({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Средний уровень'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Программа среднего уровня')),
    );
  }
}

class AdvancedProgram extends StatelessWidget {
  const AdvancedProgram({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Продвинутый уровень'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Программа продвинутого уровня')),
    );
  }
}

class MorningWorkout extends StatelessWidget {
  const MorningWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Утренняя зарядка'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Утренняя зарядка программа')),
    );
  }
}

class FlexibilityProgram extends StatelessWidget {
  const FlexibilityProgram({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Растяжка и гибкость'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Программа растяжки')),
    );
  }
}

// Medical Page

class MedicalVlogPage extends StatefulWidget {
  const MedicalVlogPage({super.key});

  @override
  State<MedicalVlogPage> createState() => _MedicalVlogPageState();
}

class _MedicalVlogPageState extends State<MedicalVlogPage> {
  int _currentIndex = 0;
  final List<MedicalArticle> _articles = [
    MedicalArticle(
      id: '1',
      title: 'Профилактика гриппа и ОРВИ в осенний период',
      author: 'Др. Иванова А.С.',
      specialty: 'Терапевт',
      content: '''
С наступлением осени резко возрастает заболеваемость гриппом и ОРВИ. Вот несколько эффективных способов защиты:

1. **Вакцинация** - самый надежный способ защиты от гриппа
2. **Гигиена рук** - мойте руки регулярно с мылом
3. **Правильное питание** - употребляйте больше витаминов
4. **Режим дня** - обеспечьте полноценный сон
5. **Проветривание** - регулярно проветривайте помещения

Помните: лучше предотвратить болезнь, чем лечить её!
      ''',
      imageUrl: 'https://via.placeholder.com/400x200',
      category: 'Профилактика',
      readTime: 5,
      likes: 42,
      comments: 8,
      publishDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    MedicalArticle(
      id: '2',
      title: 'Важность физической активности для здоровья сердца',
      author: 'Др. Петров В.И.',
      specialty: 'Кардиолог',
      content: '''
Регулярная физическая активность - ключ к здоровью сердечно-сосудистой системы.

**Рекомендации для разных возрастов:**

- **Дети 6-17 лет**: 60 минут активности ежедневно
- **Взрослые 18-64 лет**: 150 минут умеренной активности в неделю
- **Пожилые 65+**: акцент на равновесие и гибкость

Начните с малого: 30-минутная прогулка уже принесет пользу!
      ''',
      imageUrl: 'https://via.placeholder.com/400x200',
      category: 'Кардиология',
      readTime: 7,
      likes: 56,
      comments: 12,
      publishDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    MedicalArticle(
      id: '3',
      title: 'Питание для укрепления иммунитета',
      author: 'Др. Сидорова М.К.',
      specialty: 'Диетолог',
      content: '''
Правильное питание играет crucial роль в укреплении иммунной системы.

**Топ-10 продуктов для иммунитета:**

1. Цитрусовые (витамин C)
2. Красный перец
3. Брокколи
4. Чеснок
5. Имбирь
6. Шпинат
7. Йогурт
8. Миндаль
9. Куркума
10. Зеленый чай

Включайте эти продукты в свой ежедневный рацион!
      ''',
      imageUrl: 'https://via.placeholder.com/400x200',
      category: 'Питание',
      readTime: 6,
      likes: 78,
      comments: 15,
      publishDate: DateTime.now().subtract(const Duration(days: 7)),
    ),
    MedicalArticle(
      id: '4',
      title: 'Стресс и его влияние на здоровье',
      author: 'Др. Козлов Д.С.',
      specialty: 'Психотерапевт',
      content: '''
Хронический стресс может привести к серьезным проблемам со здоровьем.

**Симптомы стресса:**
- Бессонница
- Раздражительность
- Усталость
- Головные боли
- Проблемы с пищеварением

**Методы управления стрессом:**
- Медитация
- Дыхательные упражнения
- Регулярная физическая активность
- Хобби и увлечения
- Качественный сон

Не игнорируйте сигналы организма!
      ''',
      imageUrl: 'https://via.placeholder.com/400x200',
      category: 'Психология',
      readTime: 8,
      likes: 34,
      comments: 6,
      publishDate: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Медицинский блог'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddMedicalArticlePage()),
              );
            },
          ),
        ],
      ),
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        selectedItemColor: const Color.fromRGBO(236, 178, 65, 1), // Selected item color (gold)
        unselectedItemColor: Colors.grey[400], // Unselected items - light grey
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
        ),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Статьи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Видео',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.record_voice_over),
            label: 'Подкасты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Q&A',
          ),
        ],
      ),
    );
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return MedicalArticlesPage(articles: _articles);
      case 1:
        return const MedicalVideosPage();
      case 2:
        return const MedicalPodcastsPage();
      case 3:
        return const MedicalQAPage();
      default:
        return MedicalArticlesPage(articles: _articles);
    }
  }
}

// Medical Article Model
class MedicalArticle {
  final String id;
  final String title;
  final String author;
  final String specialty;
  final String content;
  final String imageUrl;
  final String category;
  final int readTime;
  final int likes;
  final int comments;
  final DateTime publishDate;

  MedicalArticle({
    required this.id,
    required this.title,
    required this.author,
    required this.specialty,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.readTime,
    required this.likes,
    required this.comments,
    required this.publishDate,
  });
}

// Medical Articles Page
class MedicalArticlesPage extends StatelessWidget {
  final List<MedicalArticle> articles;

  const MedicalArticlesPage({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return MedicalArticleCard(article: article);
      },
    );
  }
}

// Medical Article Card
class MedicalArticleCard extends StatelessWidget {
  final MedicalArticle article;

  const MedicalArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MedicalArticleDetailPage(article: article),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category and Read Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(236, 178, 65, 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      article.category,
                      style: const TextStyle(
                        color: Color.fromRGBO(236, 178, 65, 1),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${article.readTime} мин чтения',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Author Info
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${article.author} • ${article.specialty}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Image and Stats
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Content preview
                        Text(
                          article.content.split('\n').first,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        // Stats
                        Row(
                          children: [
                            _buildStat(Icons.favorite_border, article.likes.toString()),
                            const SizedBox(width: 16),
                            _buildStat(Icons.comment_outlined, article.comments.toString()),
                            const SizedBox(width: 16),
                            _buildStat(Icons.calendar_today, 
                              DateFormat('dd.MM.yyyy').format(article.publishDate)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[300],
                        image: DecorationImage(
                          image: NetworkImage(article.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

// Medical Article Detail Page
class MedicalArticleDetailPage extends StatefulWidget {
  final MedicalArticle article;

  const MedicalArticleDetailPage({super.key, required this.article});

  @override
  State<MedicalArticleDetailPage> createState() => _MedicalArticleDetailPageState();
}

class _MedicalArticleDetailPageState extends State<MedicalArticleDetailPage> {
  bool _isLiked = false;
  int _likesCount = 0;
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [];

  @override
  void initState() {
    super.initState();
    _likesCount = widget.article.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Медицинская статья'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category and Read Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(236, 178, 65, 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.article.category,
                    style: const TextStyle(
                      color: Color.fromRGBO(236, 178, 65, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${widget.article.readTime} мин чтения',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              widget.article.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            // Author Info
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.article.author,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.article.specialty,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  DateFormat('dd.MM.yyyy').format(widget.article.publishDate),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Article Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
                image: DecorationImage(
                  image: NetworkImage(widget.article.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Article Content
            Text(
              widget.article.content,
              style: const TextStyle(fontSize: 16, height: 1.6),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  _isLiked ? 'Понравилось' : 'Нравится',
                  _likesCount.toString(),
                  _isLiked ? Colors.red : Colors.grey,
                  () {
                    setState(() {
                      _isLiked = !_isLiked;
                      _likesCount += _isLiked ? 1 : -1;
                    });
                  },
                ),
                _buildActionButton(
                  Icons.comment,
                  'Комментарии',
                  _comments.length.toString(),
                  Colors.grey,
                  () {},
                ),
                _buildActionButton(
                  Icons.share,
                  'Поделиться',
                  '',
                  Colors.grey,
                  () {
                    // Share functionality
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Comments Section
            const Text(
              'Комментарии',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Add Comment
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Добавьте комментарий...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color.fromRGBO(236, 178, 65, 1)),
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      setState(() {
                        _comments.add(_commentController.text);
                        _commentController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Comments List
            ..._comments.map((comment) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(comment),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, String count, Color color, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: onPressed,
        ),
        Text(
          count,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

// Add Medical Article Page (for doctors/medics)
class AddMedicalArticlePage extends StatefulWidget {
  const AddMedicalArticlePage({super.key});

  @override
  State<AddMedicalArticlePage> createState() => _AddMedicalArticlePageState();
}

class _AddMedicalArticlePageState extends State<AddMedicalArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  bool _isLoading = false;
  String _message = '';

  Future<void> _addArticle() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      // Here you would make API call to add article
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _message = "✅ Статья успешно опубликована!";
      });
      _formKey.currentState!.reset();
    } catch (e) {
      setState(() {
        _message = "⚠️ Ошибка при публикации статьи: $e";
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
        title: const Text("Добавить статью"),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Заголовок статьи"),
                validator: (value) => value!.isEmpty ? "Введите заголовок" : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _authorController,
                      decoration: const InputDecoration(labelText: "Автор"),
                      validator: (value) => value!.isEmpty ? "Введите имя автора" : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _specialtyController,
                      decoration: const InputDecoration(labelText: "Специальность"),
                      validator: (value) => value!.isEmpty ? "Введите специальность" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Категория"),
                validator: (value) => value!.isEmpty ? "Введите категорию" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: "Ссылка на изображение"),
                validator: (value) => value!.isEmpty ? "Введите ссылку на изображение" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: "Содержание статьи"),
                maxLines: 10,
                validator: (value) => value!.isEmpty ? "Введите содержание статьи" : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(236, 178, 65, 1),
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: _addArticle,
                      child: const Text("Опубликовать статью"),
                    ),
              if (_message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _message,
                    style: TextStyle(
                      color: _message.contains("✅") ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Other medical content pages (simplified for example)
class MedicalVideosPage extends StatelessWidget {
  const MedicalVideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Медицинские видео-уроки и лекции'),
    );
  }
}

class MedicalPodcastsPage extends StatelessWidget {
  const MedicalPodcastsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Медицинские подкасты и аудиолекции'),
    );
  }
}

class MedicalQAPage extends StatelessWidget {
  const MedicalQAPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Вопросы и ответы с медиками'),
    );
  }
}


// FAQ page
class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<FAQCategory> _faqCategories = [
    FAQCategory(
      title: 'Общие вопросы',
      icon: Icons.help_outline,
      questions: [
        FAQQuestion(
          question: 'Как зарегистрироваться в приложении?',
          answer: 'Для регистрации нажмите на кнопку "Профиль" в нижнем меню, затем выберите "Зарегистрироваться". Введите ваши данные: email, пароль, имя и фамилию. После подтверждения email вы получите полный доступ ко всем функциям приложения.',
        ),
        FAQQuestion(
          question: 'Приложение бесплатное?',
          answer: 'Да, наше приложение полностью бесплатное для всех пользователей. Мы предоставляем доступ ко всем образовательным материалам, видеоурокам и функциям без каких-либо скрытых платежей или подписок.',
        ),
        FAQQuestion(
          question: 'Как восстановить пароль?',
          answer: 'На странице входа нажмите "Забыли пароль?". Введите ваш email, и мы отправим вам ссылку для восстановления пароля. Следуйте инструкциям в письме для создания нового пароля.',
        ),
        FAQQuestion(
          question: 'На каких устройствах работает приложение?',
          answer: 'Приложение работает на всех устройствах с iOS 12.0+ и Android 8.0+. Мы регулярно обновляем приложение для поддержки новых версий операционных систем.',
        ),
      ],
    ),
    FAQCategory(
      title: 'Образовательный контент',
      icon: Icons.school,
      questions: [
        FAQQuestion(
          question: 'Как получить доступ к видеокурсам?',
          answer: 'Все видеокурсы доступны в разделе "Видеокурсы" на главной странице. Вы можете фильтровать курсы по категориям и смотреть их без ограничений. Для некоторых курсов рекомендуется последовательное прохождение уроков.',
        ),
        FAQQuestion(
          question: 'Можно ли скачать видео для офлайн-просмотра?',
          answer: 'В настоящее время функция офлайн-просмотра находится в разработке. Следите за обновлениями приложения - мы планируем добавить эту функцию в ближайших версиях.',
        ),
        FAQQuestion(
          question: 'Как часто обновляется контент?',
          answer: 'Мы регулярно добавляем новые материалы: еженедельно - новые видеоуроки, ежемесячно - обновления статей и добавление новых курсов. Все пользователи получают уведомления о новых материалах.',
        ),
        FAQQuestion(
          question: 'Есть ли сертификаты о прохождении курсов?',
          answer: 'Да, после успешного прохождения полного курса вы можете получить электронный сертификат. Сертификаты доступны в разделе "Профиль" -> "Мои достижения".',
        ),
      ],
    ),
    FAQCategory(
      title: 'Технические вопросы',
      icon: Icons.settings,
      questions: [
        FAQQuestion(
          question: 'Приложение тормозит или вылетает. Что делать?',
          answer: '1. Проверьте подключение к интернету\n2. Обновите приложение до последней версии\n3. Перезагрузите устройство\n4. Очистите кэш приложения в настройках устройства\nЕсли проблема persists, напишите в службу поддержки.',
        ),
        FAQQuestion(
          question: 'Как сообщить об ошибке?',
          answer: 'Вы можете сообщить об ошибке через раздел "Настройки" -> "Обратная связь" или написав нам на email: support@schoolapp.com. Пожалуйста, укажите модель устройства, версию ОС и подробное описание проблемы.',
        ),
        FAQQuestion(
          question: 'Не воспроизводится видео. В чем проблема?',
          answer: 'Проблемы с воспроизведением видео обычно связаны с:\n1. Медленным интернет-соединением\n2. Устаревшей версией приложения\n3. Ограничениями провайдера\nПопробуйте переключиться на другую сеть Wi-Fi или используйте мобильный интернет.',
        ),
      ],
    ),
    FAQCategory(
      title: 'Медицинский раздел',
      icon: Icons.local_hospital,
      questions: [
        FAQQuestion(
          question: 'Насколько достоверна медицинская информация?',
          answer: 'Вся медицинская информация проверяется квалифицированными врачами и специалистами. Однако помните: контент предназначен для образовательных целей и не заменяет консультацию врача. При серьезных проблемах со здоровьем обращайтесь к специалистам.',
        ),
        FAQQuestion(
          question: 'Можно ли задать вопрос врачу через приложение?',
          answer: 'В настоящее время мы предоставляем образовательный контент от медицинских специалистов. Функция персональных консультаций находится в разработке. Следите за обновлениями!',
        ),
        FAQQuestion(
          question: 'Как часто обновляются медицинские статьи?',
          answer: 'Медицинские статьи обновляются еженедельно. Мы следим за последними исследованиями и рекомендациями, чтобы предоставлять актуальную информацию. Все статьи проходят медицинскую проверку перед публикацией.',
        ),
      ],
    ),
    FAQCategory(
      title: 'Библиотека и рисование',
      icon: Icons.library_books,
      questions: [
        FAQQuestion(
          question: 'Как пользоваться библиотекой?',
          answer: 'В разделе "Библиотека" вы можете:\n- Искать книги по названию, автору или категории\n- Читать книги в удобном формате\n- Сохранять закладки\n- Отслеживать прогресс чтения\nВсе книги доступны бесплатно.',
        ),
        FAQQuestion(
          question: 'Нужны ли специальные материалы для уроков рисования?',
          answer: 'Для начала подойдут базовые материалы: карандаши, бумага и ластик. В продвинутых уроках мы рекомендуем специфические материалы, но всегда предлагаем альтернативные варианты.',
        ),
        FAQQuestion(
          question: 'Можно ли сохранить свои рисунки в приложении?',
          answer: 'Да, вы можете сохранять свои работы в галерее приложения. Для этого используйте функцию "Сохранить" после завершения рисунка. Все ваши работы будут доступны в разделе "Мои работы" в профиле.',
        ),
      ],
    ),
  ];

  List<FAQCategory> _filteredCategories = [];
  Map<String, bool> _expandedState = {};

  @override
  void initState() {
    super.initState();
    _filteredCategories = _faqCategories;
    _initializeExpandedState();
  }

  void _initializeExpandedState() {
    for (var category in _faqCategories) {
      for (var question in category.questions) {
        _expandedState[question.question] = false;
      }
    }
  }

  void _filterFAQs(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredCategories = _faqCategories;
      });
    } else {
      final filtered = <FAQCategory>[];
      for (var category in _faqCategories) {
        final filteredQuestions = category.questions.where((q) =>
          q.question.toLowerCase().contains(query.toLowerCase()) ||
          q.answer.toLowerCase().contains(query.toLowerCase())
        ).toList();

        if (filteredQuestions.isNotEmpty) {
          filtered.add(FAQCategory(
            title: category.title,
            icon: category.icon,
            questions: filteredQuestions,
          ));
        }
      }
      setState(() {
        _filteredCategories = filtered;
      });
    }
  }

  void _toggleExpansion(String question) {
    setState(() {
      _expandedState[question] = !(_expandedState[question] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Часто задаваемые вопросы'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterFAQs,
              decoration: InputDecoration(
                hintText: 'Поиск по вопросам...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          // FAQ List
          Expanded(
            child: _filteredCategories.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Вопросы не найдены',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        Text(
                          'Попробуйте изменить поисковый запрос',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: _filteredCategories.length,
                    itemBuilder: (context, categoryIndex) {
                      final category = _filteredCategories[categoryIndex];
                      return _buildCategoryCard(category);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(FAQCategory category) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Header
            Row(
              children: [
                Icon(category.icon, color: const Color.fromRGBO(236, 178, 65, 1)),
                const SizedBox(width: 12),
                Text(
                  category.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Questions List
            ...category.questions.map((question) => _buildQuestionTile(question)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionTile(FAQQuestion question) {
    final isExpanded = _expandedState[question.question] ?? false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ExpansionTile(
        title: Text(
          question.question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
          color: const Color.fromRGBO(236, 178, 65, 1),
        ),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) {
          _toggleExpansion(question.question);
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              question.answer,
              style: const TextStyle(
                fontSize: 14,
                color: const Color(0xFF616161), // This is the hex for grey[700]
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// FAQ Models
class FAQCategory {
  final String title;
  final IconData icon;
  final List<FAQQuestion> questions;

  FAQCategory({
    required this.title,
    required this.icon,
    required this.questions,
  });
}

class FAQQuestion {
  final String question;
  final String answer;

  FAQQuestion({
    required this.question,
    required this.answer,
  });
}

// Contact Support Page (optional addition)
class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Служба поддержки'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Не нашли ответ на ваш вопрос?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              Icons.email,
              'Email поддержка',
              'support@schoolapp.com',
              'Ответ в течение 24 часов',
            ),
            _buildContactOption(
              Icons.chat,
              'Онлайн-чат',
              'Доступен с 9:00 до 18:00',
              'Мгновенная помощь',
            ),
            _buildContactOption(
              Icons.phone,
              'Телефонная поддержка',
              '+7 (999) 123-45-67',
              'Пн-Пт с 10:00 до 19:00',
            ),
            const SizedBox(height: 32),
            const Text(
              'Также вы можете:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Оставить отзыв в магазине приложений'),
            _buildBulletPoint('Предложить новый вопрос для FAQ'),
            _buildBulletPoint('Сообщить об ошибке в приложении'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(IconData icon, String title, String subtitle, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromRGBO(236, 178, 65, 1)),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Handle contact option tap
        },
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}


// Admin Video Page

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
