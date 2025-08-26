import 'package:flutter/foundation.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';

class ProfileProvider extends ChangeNotifier {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;

  ProfileProvider({required this.getProfile, required this.updateProfile});

  ProfileEntity? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileEntity? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasProfile => _profile != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setProfile(ProfileEntity? profile) {
    _profile = profile;
    notifyListeners();
  }

  Future<void> loadProfile(String userId) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await getProfile(GetProfileParams(userId: userId));

      result.when(
        success: (profile) {
          _setProfile(profile);
          _setError(null);
        },
        failure: (failure) {
          _setError('Failed to load profile');
          _setProfile(null);
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred');
      _setProfile(null);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserProfile(ProfileEntity updatedProfile) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await updateProfile(
        UpdateProfileParams(profile: updatedProfile),
      );

      result.when(
        success: (profile) {
          _setProfile(profile);
          _setError(null);
        },
        failure: (failure) {
          _setError('Failed to update profile');
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

  void clearProfile() {
    _setProfile(null);
  }
}
