import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_project/navbar/news_screen.dart';
import 'package:school_project/login%20and%20registr/registrationpage.dart';
import 'package:school_project/login%20and%20registr/sbrosparol.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  // Connect to your FastAPI backend
  final String apiUrl = 'http://127.0.0.1:8000/login'; // Use your IP if testing on real device

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'login': _loginController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        // ✅ Save login locally for profile page
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('login', _loginController.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Добро пожаловать, ${userData['name']}!'),
            backgroundColor: Colors.green,
          ),
        );

        // ✅ Navigate to main screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CatalogScreens()),
        );
      } else {
        final message = jsonDecode(response.body)['detail'] ?? 'Ошибка входа';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка подключения к серверу')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // --- Login Field ---
          TextFormField(
            controller: _loginController,
            decoration: const InputDecoration(
              labelText: 'Логин',
              labelStyle: TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
              ),
            ),
            style: const TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите логин';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // --- Password Field ---
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Пароль',
              labelStyle: TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
              ),
            ),
            obscureText: true,
            style: const TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите пароль';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),

          // --- Login Button ---
          ElevatedButton(
            onPressed: isLoading ? null : loginUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(236, 178, 65, 1),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Вход',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
          ),

          const SizedBox(height: 10),

          // --- Forgot Password ---
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromRGBO(236, 178, 65, 1),
            ),
            child: const Text('Забыли пароль?'),
          ),

          // --- Register ---
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RegistrationPage()),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromRGBO(236, 178, 65, 1),
            ),
            child: const Text('Регистрация'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
