import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import 'package:school_project/login and registr/login_screen.dart';

// 🌐 BASE URL for your FastAPI backend
// Use "10.0.2.2" for Android emulator, "127.0.0.1" for desktop/web testing
const String baseUrl = "http://127.0.0.1:8000";

// 🗣️ Multi-language dictionary
const Map<String, Map<String, String>> languages = {
  'ru': {
    'profile': 'Профиль',
    'privacy_policy': 'Политика конфиденциальности',
    'call_center': 'Call-Center',
    'social_networks': 'Соц. Сети',
    'logout': 'Выйти',
    'choose_language': 'Выберите язык',
    'instagram': 'Instagram',
    'telegram': 'Telegram',
    'vk': 'VK',
  },
  'en': {
    'profile': 'Profile',
    'privacy_policy': 'Privacy Policy',
    'call_center': 'Call-Center',
    'social_networks': 'Social Networks',
    'logout': 'Logout',
    'choose_language': 'Choose language',
    'instagram': 'Instagram',
    'telegram': 'Telegram',
    'vk': 'VK',
  },
  'kk': {
    'profile': 'Профиль',
    'privacy_policy': 'Құпиялылық саясаты',
    'call_center': 'Call-Center',
    'social_networks': 'Әлеуметтік желілер',
    'logout': 'Шығу',
    'choose_language': 'Тілді таңдаңыз',
    'instagram': 'Instagram',
    'telegram': 'Telegram',
    'vk': 'VK',
  },
};

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String currentLang = 'ru';
  String currentLogin = '';
  String name = '';
  String surname = '';
  String? imageUrl;
  bool isLoading = true;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 🌐 Load user info from FastAPI
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    currentLogin = prefs.getString('login') ?? '';

    if (currentLogin.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$currentLogin'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          name = data['name'];
          surname = data['surname'];
          imageUrl = data['image_url'] != null
              ? '$baseUrl${data['image_url']}'
              : null;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('❌ Error loading user: $e');
    }
  }

  String t(String key) => languages[currentLang]?[key] ?? key;

  // 🚪 Logout
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  // 📞 Call number
  Future<void> _callNumber(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // 🌐 Open social media links
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // 🌍 Language selection
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        title: Text(t('choose_language'),
            style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption('Русский', 'ru'),
            _languageOption('English', 'en'),
            _languageOption('Қазақша', 'kk'),
          ],
        ),
      ),
    );
  }

  ListTile _languageOption(String title, String code) => ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: () {
          setState(() => currentLang = code);
          Navigator.pop(context);
        },
      );

  // 📱 Social networks
  void _showSocialDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        title: Text(t('social_networks'),
            style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _socialTile(Icons.camera_alt, t('instagram'), 'https://instagram.com'),
            _socialTile(Icons.telegram, t('telegram'), 'https://t.me'),
            _socialTile(Icons.vpn_lock, t('vk'), 'https://vk.com'),
          ],
        ),
      ),
    );
  }

  ListTile _socialTile(IconData icon, String title, String url) => ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: () {
          Navigator.pop(context);
          _openUrl(url);
        },
      );

  // 🖼️ Pick & upload image
  Future<void> _pickAndUploadImage() async {
    if (isLoading || currentLogin.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("User not loaded yet")));
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() => isUploading = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/user/upload-image/$currentLogin'),
      );
      request.files.add(await http.MultipartFile.fromPath('file', pickedFile.path));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        setState(() {
          imageUrl = "${data['image_url']}?ts=${DateTime.now().millisecondsSinceEpoch}";
          isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Image uploaded successfully")),
        );
      } else {
        setState(() => isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      setState(() => isUploading = false);
      debugPrint('❌ Upload error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error uploading image: $e")));
    }
  }

  // 🧱 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
      appBar: AppBar(
        title: Text(t('profile')),
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Column(
                children: [
                  GestureDetector(
                    onTap: _pickAndUploadImage,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: imageUrl != null
                              ? NetworkImage(imageUrl!)
                              : const AssetImage('assets/desktop/1photo.png')
                                  as ImageProvider,
                        ),
                        if (isUploading)
                          const CircularProgressIndicator(color: Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$name $surname',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: ListView(
                      children: [
                        _menuTile(Icons.language, t('choose_language'),
                            _showLanguageDialog),
                        _menuTile(Icons.security, t('privacy_policy'),
                            () => _openUrl('https://yourwebsite.com/privacy')),
                        _menuTile(Icons.call, t('call_center'),
                            () => _callNumber('+77001234567')),
                        _menuTile(Icons.people, t('social_networks'),
                            _showSocialDialog),
                        _menuTile(Icons.exit_to_app, t('logout'), _logout),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  ListTile _menuTile(IconData icon, String title, Function() onTap) => ListTile(
        leading: Icon(icon, color: const Color.fromRGBO(236, 178, 65, 1)),
        title:
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        onTap: onTap,
      );
}
