import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../../core/constants.dart';
import '../../../../app/router.dart';
import '../../../../core/utils/cache_helper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationDurationSlow,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();

    // Initialize cache and check authentication status
    _initializeAndCheckAuth();
  }

  Future<void> _initializeAndCheckAuth() async {
    // Initialize CacheHelper
    await CacheHelper.init();

    // Wait for animation to complete
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      _checkAuthenticationAndNavigate();
    }
  }

  bool isSignIn() {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    final uId = _getCachedUserId();

    print('uuuuuuuu $uId');
    print(user == null ? 'kkkkkpp' : user.uid);

    // Check if user is signed in to Firebase
    if (user?.uid != null) {
      // If we have a Firebase user, check if we also have cached uId
      if (uId != null && uId.isNotEmpty) {
        print(user?.uid);
        print('uuuuuuuu ');
        return true;
      } else {
        // User is signed in to Firebase but no cached uId
        // This might happen on first app launch after sign in
        // We can still consider them signed in
        print('User signed in to Firebase but no cached uId');
        return true;
      }
    } else {
      return false;
    }
  }

  String? _getCachedUserId() {
    return CacheHelper.getData(key: 'uId');
  }

  void _checkAuthenticationAndNavigate() {
    final isUserSignedIn = isSignIn();
    print('Authentication check result: $isUserSignedIn');

    if (isUserSignedIn) {
      // User is signed in, navigate to products page
      print('Navigating to products page');
      Navigator.pushReplacementNamed(context, AppRouter.products);
    } else {
      // User is not signed in, navigate to login page
      print('Navigating to login page');
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, size: 100, color: Colors.white),
                    const SizedBox(height: AppConstants.paddingLarge),
                    Text(
                      'Mini E-Commerce',
                      style: AppConstants.headingStyle.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      'Your one-stop shopping destination',
                      style: AppConstants.bodyStyle.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
