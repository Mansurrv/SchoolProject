import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:school_project/navbar/language_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import 'package:school_project/login and registr/login_screen.dart';
import 'package:school_project/navbar/homepage.dart';
import 'package:school_project/navbar/news_screen.dart';
import 'package:school_project/navbar/searchpage.dart';
import 'package:school_project/navbar/language_provider.dart';

// 🌐 BASE URL for your FastAPI backend
const String baseUrl = "http://127.0.0.1:8000";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  // 🌍 Language selection - UPDATED TO CHANGE WHOLE APP
  void _showLanguageDialog(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        title: Text(languageProvider.translate('choose_language'),
            style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption('Русский', 'ru', languageProvider),
            _languageOption('English', 'en', languageProvider),
            _languageOption('Қазақша', 'kk', languageProvider),
          ],
        ),
      ),
    );
  }

  ListTile _languageOption(String title, String code, LanguageProvider languageProvider) => ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: () {
          languageProvider.setLanguage(code); // This will update the whole app
          Navigator.pop(context);
        },
      );

  // 📱 Social networks
  void _showSocialDialog(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
        title: Text(languageProvider.translate('social_networks'),
            style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _socialTile(Icons.camera_alt, languageProvider.translate('instagram'), 'https://instagram.com'),
            _socialTile(Icons.telegram, languageProvider.translate('telegram'), 'https://t.me'),
            _socialTile(Icons.vpn_lock, languageProvider.translate('vk'), 'https://vk.com'),
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

  // 🧱 UI - UPDATED TO USE CONSUMER FOR REACTIVE UPDATES
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
          appBar: AppBar(
            title: Text(languageProvider.translate('profile')),
            backgroundColor: const Color.fromRGBO(23, 21, 21, 1),
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          languageProvider.translate('loading'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
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
                            _menuTile(
                              Icons.language, 
                              languageProvider.translate('choose_language'),
                              () => _showLanguageDialog(context),
                            ),
                            _menuTile(
                              Icons.security, 
                              languageProvider.translate('privacy_policy'),
                              () => _openUrl('https://yourwebsite.com/privacy'),
                            ),
                            _menuTile(
                              Icons.call, 
                              languageProvider.translate('call_center'),
                              () => _callNumber('+77001234567'),
                            ),
                            _menuTile(
                              Icons.people, 
                              languageProvider.translate('social_networks'),
                              () => _showSocialDialog(context),
                            ),
                            _menuTile(
                              Icons.exit_to_app, 
                              languageProvider.translate('logout'), 
                              _logout,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(23, 21, 21, 1),
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
                _navButton(context, Icons.apps_outlined, 45, CatalogScreens(), languageProvider.translate('news')),
                _navButton(context, Icons.search, 45, SearchPage(), languageProvider.translate('search')),
                _navButton(context, Icons.home, 45, HomePage(), languageProvider.translate('home')),
                _navButton(context, Icons.library_books, 45, LibraryPage(), languageProvider.translate('library')),
                _navButton(context, Icons.account_circle, 35, ProfilePage(), languageProvider.translate('profile')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _menuTile(IconData icon, String title, Function() onTap) => ListTile(
        leading: Icon(icon, color: const Color.fromRGBO(236, 178, 65, 1)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        onTap: onTap,
      );

  Widget _navButton(BuildContext context, IconData icon, double size, Widget page, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => page),
        ),
        icon: Icon(icon),
        iconSize: size,
        color: const Color.fromRGBO(236, 178, 65, 1),
      ),
    );
  }
}