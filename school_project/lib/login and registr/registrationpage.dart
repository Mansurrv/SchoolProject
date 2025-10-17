import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:school_project/login%20and%20registr/login_screen.dart';
import 'package:school_project/navbar/news_screen.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2018, 1, 1),
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color.fromRGBO(236, 178, 65, 1),
              onPrimary: Colors.black,
              surface: Color.fromRGBO(23, 21, 21, 1),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _registerUser() async {
    final url = Uri.parse('http://127.0.0.1:8000/register'); 

    final Map<String, dynamic> userData = {
      "login": _loginController.text,
      "password": _passwordController.text,
      "name": _nameController.text,
      "surname": _surnameController.text,
      "birth_date": _selectedDate?.toIso8601String(),
      "email": _emailController.text,
    };

    print('📤 Sending registration data: $userData');

    try {
      final response = await http.post(   
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      print('✅ Response code: ${response.statusCode}');
      print('✅ Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Регистрация успешна!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CatalogScreens()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${response.body}')),
        );
      }
    } catch (e) {
      print('❌ Connection error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка соединения: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _loginController,
                  decoration: const InputDecoration(
                    labelText: 'Логин',
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
                    ),
                  ),
                  style: const TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Введите логин' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
                    ),
                  ),
                  style: const TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите пароль';
                    }
                    if (value.length < 6) {
                      return 'Минимум 6 символов';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Имя',
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
                    ),
                  ),
                  style: const TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Введите имя' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _surnameController,
                  decoration: const InputDecoration(
                    labelText: 'Фамилия',
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
                    ),
                  ),
                  style: const TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Введите фамилию' : null,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: _selectedDate == null
                            ? 'Дата рождения'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        labelStyle: const TextStyle(
                            color: Color.fromRGBO(236, 178, 65, 1)),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(236, 178, 65, 1)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(236, 178, 65, 1)),
                        ),
                      ),
                      style: const TextStyle(
                          color: Color.fromRGBO(236, 178, 65, 1)),
                      validator: (value) => _selectedDate == null
                          ? 'Выберите дату рождения'
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Почта',
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(236, 178, 65, 1)),
                    ),
                  ),
                  style: const TextStyle(color: Color.fromRGBO(236, 178, 65, 1)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите почту';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Некорректная почта';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _registerUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(236, 178, 65, 1),
                  ),
                  child: const Text('Зарегистрироваться'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: RegistrationPage()));
}
