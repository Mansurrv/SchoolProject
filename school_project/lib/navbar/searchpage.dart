import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      appBar: AppBar(
        title: const Text('Поиск'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(23, 21, 21, 1),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (query) => _filterSearchResults(query),
              decoration: const InputDecoration(
                labelText: 'Введите запрос для поиска',
                labelStyle: TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
                prefixIcon: Icon(Icons.search, color: Color.fromRGBO(236, 178, 65, 1)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
                ),
              ),
              style: const TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : _filteredItems.isEmpty
                      ? const Center(
                          child: Text(
                            "Ничего не найдено",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                _filteredItems[index],
                                style: const TextStyle(color: Colors.white),
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

void main() {
  runApp(const MaterialApp(
    home: SearchPage(),
  ));
}
