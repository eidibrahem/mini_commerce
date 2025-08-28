import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/di/injector.dart';
import '../app/theme.dart';
import '../app/router.dart';
import '../core/localization/language_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/products/presentation/providers/product_provider.dart';
import '../features/cart/presentation/providers/cart_provider.dart';
import '../features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MiniCommerceApp extends StatelessWidget {
  const MiniCommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => getIt<AuthProvider>(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => getIt<ProductProvider>(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => getIt<CartProvider>(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => getIt<ProfileProvider>(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (_) => LanguageProvider(),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Mini E-Commerce',
            locale: languageProvider.currentLocale,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            initialRoute: AppRouter.splash,
            onGenerateRoute: AppRouter.generateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
