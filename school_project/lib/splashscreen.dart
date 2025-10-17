import 'package:flutter/material.dart';
import 'login and registr/login_screen.dart'; // Импорт HomeScreen для перехода

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/desktop/1photo.png', // Путь к вашему логотипу
              width: 250,
              height: 250,
            ),
            const SizedBox(height: 20),
            const Text(
              'Привет, давай вместе учиться!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}