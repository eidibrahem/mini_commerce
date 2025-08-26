import 'package:flutter/material.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/products/presentation/pages/products_page.dart';
import '../features/cart/presentation/pages/cart_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String products = '/products';
  static const String cart = '/cart';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case products:
        return MaterialPageRoute(builder: (_) => const ProductsPage());
      case cart:
        return MaterialPageRoute(builder: (_) => const CartPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
