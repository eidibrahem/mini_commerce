import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  Locale _currentLocale = const Locale('en', 'US');
  bool _isLoading = false;

  Locale get currentLocale => _currentLocale;
  bool get isLoading => _isLoading;
  bool get isRTL => _currentLocale.languageCode == 'ar';

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);

      if (languageCode != null) {
        if (languageCode == 'ar') {
          _currentLocale = const Locale('ar', 'SA');
        } else {
          _currentLocale = const Locale('en', 'US');
        }
        notifyListeners();
      }
    } catch (e) {
      print('Error loading saved language: $e');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      Locale newLocale;
      if (languageCode == 'ar') {
        newLocale = const Locale('ar', 'SA');
      } else {
        newLocale = const Locale('en', 'US');
      }

      if (_currentLocale != newLocale) {
        _currentLocale = newLocale;

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, languageCode);

        notifyListeners();
      }
    } catch (e) {
      print('Error changing language: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeToEnglish() async {
    await changeLanguage('en');
  }

  Future<void> changeToArabic() async {
    await changeLanguage('ar');
  }

  String getLanguageName() {
    switch (_currentLocale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
      default:
        return 'English';
    }
  }

  String getLanguageCode() {
    return _currentLocale.languageCode;
  }

  bool isEnglish() {
    return _currentLocale.languageCode == 'en';
  }

  bool isArabic() {
    return _currentLocale.languageCode == 'ar';
  }
}
