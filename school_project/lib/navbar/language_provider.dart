import 'package:flutter/material.dart';

// 🗣️ Multi-language dictionary for the whole app
const Map<String, Map<String, String>> languages = {
  'ru': {
    // Profile Page
    'profile': 'Профиль',
    'privacy_policy': 'Политика конфиденциальности',
    'call_center': 'Call-Center',
    'social_networks': 'Соц. Сети',
    'logout': 'Выйти',
    'choose_language': 'Выберите язык',
    'instagram': 'Instagram',
    'telegram': 'Telegram',
    'vk': 'VK',
    
    // Navigation
    'news': 'Новости',
    'search': 'Поиск',
    'home': 'Главная',
    'library': 'Библиотека',
    
    // Home Page Items
    'video_courses': 'Видеокурсы',
    'drawing': 'Рисование',
    'training': 'Тренировка',
    'medical_blog': 'Влог от медиков',
    'faq': 'FAQ',
    
    // Training Page
    'workout_programs': 'Программы',
    'exercises': 'Упражнения',
    'progress': 'Прогресс',
    'schedule': 'Расписание',
    
    // Drawing Page
    'lessons': 'Уроки',
    'techniques': 'Техники',
    
    // Medical Blog
    'articles': 'Статьи',
    'podcasts': 'Подкасты',
    'qa': 'Q&A',
    
    // Common
    'loading': 'Загрузка...',
    'error': 'Ошибка',
    'success': 'Успешно',
  },
  'en': {
    // Profile Page
    'profile': 'Profile',
    'privacy_policy': 'Privacy Policy',
    'call_center': 'Call-Center',
    'social_networks': 'Social Networks',
    'logout': 'Logout',
    'choose_language': 'Choose language',
    'instagram': 'Instagram',
    'telegram': 'Telegram',
    'vk': 'VK',
    
    // Navigation
    'news': 'News',
    'search': 'Search',
    'home': 'Home',
    'library': 'Library',
    
    // Home Page Items
    'video_courses': 'Video Courses',
    'drawing': 'Drawing',
    'training': 'Training',
    'medical_blog': 'Medical Blog',
    'faq': 'FAQ',
    
    // Training Page
    'workout_programs': 'Programs',
    'exercises': 'Exercises',
    'progress': 'Progress',
    'schedule': 'Schedule',
    
    // Drawing Page
    'lessons': 'Lessons',
    'techniques': 'Techniques',
    
    // Medical Blog
    'articles': 'Articles',
    'podcasts': 'Podcasts',
    'qa': 'Q&A',
    
    // Common
    'loading': 'Loading...',
    'error': 'Error',
    'success': 'Success',
  },
  'kk': {
    // Profile Page
    'profile': 'Профиль',
    'privacy_policy': 'Құпиялылық саясаты',
    'call_center': 'Call-Center',
    'social_networks': 'Әлеуметтік желілер',
    'logout': 'Шығу',
    'choose_language': 'Тілді таңдаңыз',
    'instagram': 'Instagram',
    'telegram': 'Telegram',
    'vk': 'VK',
    
    // Navigation
    'news': 'Жаңалықтар',
    'search': 'Іздеу',
    'home': 'Басты',
    'library': 'Кітапхана',
    
    // Home Page Items
    'video_courses': 'Бейнекурстар',
    'drawing': 'Сурет салу',
    'training': 'Жаттығу',
    'medical_blog': 'Медициналық блог',
    'faq': 'Жиі қойылатын сұрақтар',
    
    // Training Page
    'workout_programs': 'Бағдарламалар',
    'exercises': 'Жаттығулар',
    'progress': 'Прогресс',
    'schedule': 'Кесте',
    
    // Drawing Page
    'lessons': 'Сабақтар',
    'techniques': 'Техникалар',
    
    // Medical Blog
    'articles': 'Мақалалар',
    'podcasts': 'Подкасттар',
    'qa': 'Сұрақ-жауап',
    
    // Common
    'loading': 'Жүктелуде...',
    'error': 'Қате',
    'success': 'Сәтті',
  },
};

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'ru';

  String get currentLanguage => _currentLanguage;

  void setLanguage(String language) {
    _currentLanguage = language;
    notifyListeners(); // This will rebuild all widgets listening to this provider
  }

  String translate(String key) {
    return languages[_currentLanguage]?[key] ?? key;
  }
}