import 'package:flutter/material.dart';
import 'package:school_project/navbar/homepage.dart';
import 'package:school_project/navbar/profilepage.dart';
import 'package:school_project/navbar/searchpage.dart';

class CatalogScreens extends StatelessWidget {
  const CatalogScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(
          left: 0.0,
          top: 0.0,
          right: 0.0,
          bottom: 0.0,
        ),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(23, 21, 21, 1),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 100, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Баннер с анимацией прокрутки
              SizedBox(
                height: 200,  // Установлено 50 пикселей
                width: double.infinity, // Ширина на весь экран
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage('assets/desktop/samar.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage('assets/desktop/samar.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage('assets/desktop/samar.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Новости от Логопеда',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromRGBO(236, 178, 65, 1)),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Card(
                        child: Container(
                          width: 160,
                          constraints: const BoxConstraints(maxWidth: 160),
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/desktop/1photo.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text('Новости ${index + 1}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Новости',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromRGBO(236, 178, 65, 1)),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Card(
                        child: Container(
                          width: 160,
                          constraints: const BoxConstraints(maxWidth: 160),
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/buket.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text('Новости ${index + 1}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 85),
            ],
          ),
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

class NewCatalogScreen extends StatelessWidget {
  const NewCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Catalog Screen")),
      body: const Center(child: Text("This is a new catalog screen")),
    );
  }
}
