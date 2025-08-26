import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini_commerce/features/auth/data/datasources/localdatasource/cache_helper.dart';
import 'package:mini_commerce/firebase_options.dart';
import 'app/app.dart';
import 'app/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  // Initialize dependencies
  await initializeDependencies();

  runApp(const MiniCommerceApp());
}
