import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:school_project/navbar/news_screen.dart'; // Import your news screen

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _allItems = [];
  List<String> _filteredItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchItemsFromBackend();
  }

  // --- Fetch users from FastAPI backend ---
  Future<void> _fetchItemsFromBackend() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/items'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          _allItems = data.map((item) => item['name'].toString()).toList();
          _filteredItems = _allItems;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        print('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Error fetching items: $e');
    }
  }

  // --- Filter search results locally ---
  void _filterSearchResults(String query) {
    List<String> results = [];
    if (query.isNotEmpty) {
      results = _allItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      results = _allItems;
    }
    setState(() {
      _filteredItems = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
      appBar: AppBar(
        title: const Text(
          'Поиск',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () {
            // Navigate back to News Screen (CatalogScreens)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CatalogScreens()),
            );
          },
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color.fromRGBO(23, 21, 21, 1),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color.fromRGBO(236, 178, 65, 1),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (query) => _filterSearchResults(query),
                decoration: const InputDecoration(
                  hintText: 'Введите запрос для поиска...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Color.fromRGBO(236, 178, 65, 1)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: const Color.fromRGBO(236, 178, 65, 1),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Results Section
            Expanded(
              child: isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Color.fromRGBO(236, 178, 65, 1),
                            strokeWidth: 3,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Загрузка...",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : _filteredItems.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Ничего не найдено",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Попробуйте изменить поисковый запрос",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.grey[900],
                              margin: const EdgeInsets.only(bottom: 8),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(236, 178, 65, 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.description,
                                    color: const Color.fromRGBO(236, 178, 65, 1),
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  _filteredItems[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey[600],
                                  size: 16,
                                ),
                                onTap: () {
                                  // Handle item tap
                                  print('Tapped: ${_filteredItems[index]}');
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}