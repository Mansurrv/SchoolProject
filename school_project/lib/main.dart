
import 'package:flutter/material.dart';
import 'package:school_project/splashscreen.dart';
import 'login and registr/login_screen.dart';
import 'navbar/news_screen.dart';
import 'package:school_project/login%20and%20registr/registrationpage.dart'; // Корректный импорт
import 'navbar/searchpage.dart';
import 'navbar/profilepage.dart';
import 'navbar/homepage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Отключает баннер "Debug"
      title: 'Login Demo', // Заголовок приложения
      theme: ThemeData(primarySwatch: Colors.blue), // Тема приложения
      initialRoute: '/splashscreen', // Начальный маршрут
      routes: {
        '/splashscreen': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home_screen': (context) => CatalogScreens(),
        '/homepage': (context) => HomePage(),
        
      },
    );
  }
}


