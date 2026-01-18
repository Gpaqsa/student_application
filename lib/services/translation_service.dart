import 'dart:convert';
import 'package:flutter/services.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  late Map<String, Map<String, String>> _translations;

  factory TranslationService() {
    return _instance;
  }

  TranslationService._internal();

  /// Initialize translations from JSON file
  Future<void> init() async {
    final String jsonString =
        await rootBundle.loadString('assets/translations.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _translations = {};
    jsonMap.forEach((language, translations) {
      _translations[language] = Map<String, String>.from(
          translations as Map<dynamic, dynamic>);
    });
  }

  /// Get translation for a key in the specified language
  /// Returns the key itself if translation is not found
  String get(String key, String language) {
    if (!_translations.containsKey(language)) {
      return key;
    }
    return _translations[language]![key] ?? key;
  }

  /// Get all available languages
  List<String> getAvailableLanguages() {
    return _translations.keys.toList();
  }

  /// Check if a language is available
  bool isLanguageAvailable(String language) {
    return _translations.containsKey(language);
  }
}
