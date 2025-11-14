import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_project/navbar/language_provider.dart';
import 'package:school_project/navbar/language_provider.dart';
import 'package:school_project/splashscreen.dart';
import 'login and registr/login_screen.dart';
import 'navbar/news_screen.dart';
import 'package:school_project/login%20and%20registr/registrationpage.dart';
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
    return ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/splashscreen',
        routes: {
          '/splashscreen': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/home_screen': (context) => CatalogScreens(),
          '/homepage': (context) => HomePage(),
          '/search': (context) => SearchPage(),
          '/profile': (context) => ProfilePage(),
          '/library': (context) => LibraryPage(),
          '/registration': (context) => RegistrationPage(),
        },
      ),
    );
  }
}