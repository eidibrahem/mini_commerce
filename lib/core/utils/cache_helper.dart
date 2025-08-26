import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    await init();
    if (value is String) {
      return await _prefs!.setString(key, value);
    } else if (value is int) {
      return await _prefs!.setInt(key, value);
    } else if (value is bool) {
      return await _prefs!.setBool(key, value);
    } else if (value is double) {
      return await _prefs!.setDouble(key, value);
    } else if (value is List<String>) {
      return await _prefs!.setStringList(key, value);
    }
    return false;
  }

  static dynamic getData({required String key}) {
    return _prefs?.get(key);
  }

  static String? getString({required String key}) {
    return _prefs?.getString(key);
  }

  static int? getInt({required String key}) {
    return _prefs?.getInt(key);
  }

  static bool? getBool({required String key}) {
    return _prefs?.getBool(key);
  }

  static double? getDouble({required String key}) {
    return _prefs?.getDouble(key);
  }

  static List<String>? getStringList({required String key}) {
    return _prefs?.getStringList(key);
  }

  static Future<bool> removeData({required String key}) async {
    await init();
    return await _prefs!.remove(key);
  }

  static Future<bool> clearData() async {
    await init();
    return await _prefs!.clear();
  }

  static bool hasData({required String key}) {
    return _prefs?.containsKey(key) ?? false;
  }
}
