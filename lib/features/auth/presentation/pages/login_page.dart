import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants.dart';
import '../../../../app/router.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Listen to auth state changes and navigate on success
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      authProvider.addListener(_onAuthStateChanged);
    });
  }

  @override
  void dispose() {
    final authProvider = context.read<AuthProvider>();
    authProvider.removeListener(_onAuthStateChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onAuthStateChanged() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isAuthenticated && authProvider.errorMessage == null) {
      // Navigate to products page on successful authentication
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.products,
        (route) => false, // Remove all previous routes
      );
    }
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      authProvider.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  void _signInWithGoogle() {
    final authProvider = context.read<AuthProvider>();
    authProvider.signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.shopping_cart,
                  size: 80,
                  color: AppConstants.primaryColor,
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                Text(
                  'Welcome Back',
                  style: AppConstants.headingStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                Text(
                  'Sign in to continue shopping',
                  style: AppConstants.captionStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingXLarge),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),

                // Sign In Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _signIn,
                      child:
                          authProvider.isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text('Sign In'),
                    );
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),

                // Google Sign In Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return OutlinedButton.icon(
                      onPressed:
                          authProvider.isLoading ? null : _signInWithGoogle,
                      icon: const Icon(Icons.g_mobiledata),
                      label: const Text('Sign in with Google'),
                    );
                  },
                ),
                const SizedBox(height: AppConstants.paddingLarge),

                // Error Message
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    if (authProvider.errorMessage != null) {
                      return Container(
                        padding: const EdgeInsets.all(
                          AppConstants.paddingMedium,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusMedium,
                          ),
                        ),
                        child: Text(
                          authProvider.errorMessage!,
                          style: TextStyle(color: AppConstants.errorColor),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                const Spacer(),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppConstants.bodyStyle,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.signup);
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
