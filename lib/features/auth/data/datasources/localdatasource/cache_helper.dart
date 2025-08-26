import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;


  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool?> putData(
      {required String key, required bool value}) async {
    return await sharedPreferences?.setBool(key, value);
  }

  static Future<bool?> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences?.setString(key, value);
    if (value is int) return await sharedPreferences?.setInt(key, value);
    if (value is bool) return await sharedPreferences?.setBool(key, value);
    return await sharedPreferences?.setDouble(key, value);
  }

  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences?.get(key);
  }

  static Future<bool?> removeData({
    required String key,
  }) async {
    return await sharedPreferences?.remove(key);
  }

  static Future<bool?> removeAll() async {
    await sharedPreferences?.remove('name');
    await sharedPreferences?.remove('email');
    await sharedPreferences?.remove('phon');
    return await sharedPreferences?.remove('token');
  }

  static   Future<Locale> getLocal() async {
    var local ;
    local=  sharedPreferences?.getString('local') ;  
    if (local== null || local == 'ar') {
      if (kDebugMode) {
        local  == null ? print('null la') : print('ar');
      }
      return Locale('ar');
    } else {
      if (kDebugMode) {
        print('ar');
      }
      return  Locale('en');
    }
  }
}
