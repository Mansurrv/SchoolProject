import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_project/login%20and%20registr/login_screen.dart'; // Ваш экран входа
import 'package:school_project/navbar/news_screen.dart'; // Экран после подтверждения

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyCode = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();

  bool _isCodeStep = false;

  static const String baseUrl = 'http://127.0.0.1:8000'; // Замените на ваш backend URL

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submitEmail() async {
    if (_formKeyEmail.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/forgot-password'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': _emailController.text}),
        );

        if (response.statusCode == 200) {
          setState(() {
            _isCodeStep = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Код отправлен на указанную почту')),
          );
        } else {
          final error = jsonDecode(response.body)['detail'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error ?? 'Ошибка при отправке кода')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }

  Future<void> _submitCode() async {
    if (_formKeyCode.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/verify-code'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _emailController.text,
            'code': _codeController.text
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Код подтвержден!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CatalogScreens()),
          );
        } else {
          final error = jsonDecode(response.body)['detail'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error ?? 'Неверный код')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Забыли пароль'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isCodeStep ? _buildCodeStep() : _buildEmailStep(),
      ),
    );
  }

  Widget _buildEmailStep() {
    return Form(
      key: _formKeyEmail,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Введите вашу почту',
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
                return 'Пожалуйста, введите почту';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Введите действительный адрес почты';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitEmail,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(236, 178, 65, 1),
            ),
            child: const Text('Отправить код'),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeStep() {
    return Form(
      key: _formKeyCode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Введите код из почты',
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
                return 'Пожалуйста, введите код';
              }
              if (!RegExp(r'^\d+$').hasMatch(value)) {
                return 'Код должен содержать только цифры';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(236, 178, 65, 1),
            ),
            child: const Text('Подтвердить'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ForgotPasswordPage(),
  ));
}
