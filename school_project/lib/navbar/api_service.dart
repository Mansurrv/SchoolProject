import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000";

  static Future<List<dynamic>> getNews() async {
    final response = await http.get(Uri.parse("$baseUrl/news"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load news");
    }
  }

  static Future<List<dynamic>> getNewsByCategory(String category) async {
    final response = await http.get(Uri.parse("$baseUrl/news/category/$category"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  static Future<List<dynamic>> getLogopedNews() async {
    final response = await http.get(Uri.parse("$baseUrl/logoped-news"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

    // --- Banners ---
  static Future<List<dynamic>> getBanners() async {
    final response = await http.get(Uri.parse("$baseUrl/banners"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load banners");
    }
  }
}
