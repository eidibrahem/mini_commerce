import 'package:flutter/foundation.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/sign_in_email.dart';
import '../../domain/usecases/sign_in_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';

class AuthProvider extends ChangeNotifier {
  final SignInEmail signInEmail;
  final SignInGoogle signInGoogle;
  final SignUp signUp;
  final SignOut signOut;

  AuthProvider({
    required this.signInEmail,
    required this.signInGoogle,
    required this.signUp,
    required this.signOut,
  });

  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setUser(UserEntity? user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await signInEmail(
        SignInEmailParams(email: email, password: password),
      );

      result.when(
        success: (user) {
          _setUser(user);
          _setError(null);
        },
        failure: (failure) {
          _setError(failure.message);
          _setUser(null);
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred');
      _setUser(null);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await signInGoogle(NoParams());

      result.when(
        success: (user) {
          _setUser(user);
          _setError(null);
        },
        failure: (failure) {
          _setError(failure.message);
          _setUser(null);
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred');
      _setUser(null);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUpUser(String email, String password, String name) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await signUp(
        SignUpParams(email: email, password: password, name: name),
      );

      result.when(
        success: (user) {
          _setUser(user);
          _setError(null);
        },
        failure: (failure) {
          _setError(failure.message);
          _setUser(null);
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred');
      _setUser(null);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOutUser() async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await signOut(NoParams());

      result.when(
        success: (_) {
          _setUser(null);
          _setError(null);
        },
        failure: (failure) {
          _setError(failure.message);
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred');
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _setError(null);
  }
}
