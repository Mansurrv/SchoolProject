import 'package:flutter/material.dart';
import 'package:school_project/navbar/homepage.dart';
import 'package:school_project/navbar/profilepage.dart';
import 'package:school_project/navbar/searchpage.dart';
import '../navbar/api_service.dart';

class CatalogScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 21, 21, 1),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: Color.fromRGBO(23, 21, 21, 1),
            elevation: 0,
            pinned: true,
            expandedHeight: 120.0,
            automaticallyImplyLeading: false, // This removes the back button
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Новости',
                style: TextStyle(
                  color: Color.fromRGBO(236, 178, 65, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(23, 21, 21, 1),
                      Color.fromRGBO(40, 38, 38, 1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 20),
              
              // Banner Section
              _bannerSection(),
              
              SizedBox(height: 30),
              
              // Logoped News Section
              _newsSection('Новости от Логопеда', ApiService.getLogopedNews()),
              
              SizedBox(height: 30),
              
              // General News Section
              _newsSection('Последние новости', ApiService.getNews()),
              
              SizedBox(height: 85),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  // ... rest of your methods remain exactly the same ...

  // Banner Section
  Widget _bannerSection() {
    return FutureBuilder<List<dynamic>>(
      future: ApiService.getBanners(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildBannerLoading();
        } else if (snapshot.hasError) {
          return _buildBannerError();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildNoBanners();
        }

        final banners = snapshot.data!;
        return Container(
          height: 200,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PageView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return _bannerCard(
                banner['title'] ?? 'Баннер',
                banner['image_url'],
                banner['description'] ?? '',
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBannerLoading() {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: CircularProgressIndicator(
          color: Color.fromRGBO(236, 178, 65, 1),
        ),
      ),
    );
  }

  Widget _buildBannerError() {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              "Ошибка загрузки",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoBanners() {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_search, size: 50, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              "Баннеры отсутствуют",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannerCard(String title, String? imageUrl, String description) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Image
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    imageUrl ?? 'https://via.placeholder.com/400x200/1a1a1a/333333',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Gradient Overlay
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // News Section
  Widget _newsSection(String title, Future<List<dynamic>> futureNews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(236, 178, 65, 1),
                ),
              ),
              Text(
                'Смотреть все',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 16),
        
        // News List
        FutureBuilder<List<dynamic>>(
          future: futureNews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildNewsLoading();
            } else if (snapshot.hasError) {
              return _buildNewsError();
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildNoNews();
            }

            final newsList = snapshot.data!;
            return Container(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final news = newsList[index];
                  return _newsCard(
                    context,
                    news['title'] ?? 'Без названия',
                    news['image_url'],
                    news['description'] ?? 'Описание отсутствует',
                    news['date'] ?? 'Недавно',
                    news['author'] ?? 'Автор неизвестен',
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNewsLoading() {
    return Container(
      height: 220,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 160,
            margin: EdgeInsets.only(right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Loading image
                Container(
                  width: 160,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(236, 178, 65, 1),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                // Loading title
                Container(
                  width: 160,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 4),
                // Loading date
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsError() {
    return Container(
      height: 220,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 40, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              "Ошибка загрузки новостей",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoNews() {
    return Container(
      height: 220,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article, size: 40, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              "Новостей пока нет",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _newsCard(BuildContext context, String title, String? imageUrl, 
      String description, String date, String author) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              title: title,
              imageUrl: imageUrl,
              description: description,
              date: date,
              author: author,
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News Image
            Container(
              width: 160,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    // Image
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            imageUrl ?? 'https://via.placeholder.com/160x120/2a2a2a/444444',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 8),
            
            // News Title
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            SizedBox(height: 4),
            
            // News Date and Author
            Row(
              children: [
                Icon(Icons.calendar_today, size: 10, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 2),
            
            Text(
              'by $author',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Navigation Bar
  Widget _bottomNavBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(23, 21, 21, 1),
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
          _navButton(context, Icons.library_books, 45, NewCatalogScreen()),
          _navButton(context, Icons.account_circle, 35, ProfilePage()),
        ],
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
      color: Color.fromRGBO(236, 178, 65, 1),
    );
  }
}

// News Detail Page
class NewsDetailPage extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String description;
  final String date;
  final String author;

  const NewsDetailPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.date,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 21, 21, 1),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroImage(),
            ),
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Meta Information
                  Row(
                    children: [
                      _buildMetaItem(Icons.person, author),
                      SizedBox(width: 16),
                      _buildMetaItem(Icons.calendar_today, date),
                      SizedBox(width: 16),
                      _buildMetaItem(Icons.timer, '5 мин чтения'),
                    ],
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Content
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(236, 178, 65, 1),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // Share functionality
                          },
                          icon: Icon(Icons.share, color: Colors.white),
                          label: Text(
                            'Поделиться',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // Save functionality
                          },
                          icon: Icon(Icons.bookmark_border, color: Colors.white),
                          label: Text(
                            'Сохранить',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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

  Widget _buildHeroImage() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                imageUrl ?? 'https://via.placeholder.com/400x300/2a2a2a/444444',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromRGBO(23, 21, 21, 0.9),
                Colors.transparent,
                Colors.transparent,
                Color.fromRGBO(23, 21, 21, 0.3),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Color.fromRGBO(236, 178, 65, 1)),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

class NewCatalogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Catalog Screen")),
      body: Center(child: Text("This is a new catalog screen")),
    );
  }
}