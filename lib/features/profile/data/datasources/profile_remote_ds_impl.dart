import '../../../../core/utils/result.dart';
import '../models/profile_model.dart';
import 'profile_remote_ds.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileModel? _mockProfile;

  @override
  Future<Result<ProfileModel>> getProfile(String userId) async {
    await Future.delayed(const Duration(seconds: 1));

    // Create mock profile if it doesn't exist
    _mockProfile ??= ProfileModel(
      id: 'profile_$userId',
      userId: userId,
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '+1234567890',
      address: '123 Main St',
      city: 'New York',
      state: 'NY',
      zipCode: '10001',
      country: 'USA',
      dateOfBirth: DateTime(1990, 1, 1),
      profileImageUrl: 'https://example.com/profile.jpg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return Success(_mockProfile!);
  }

  @override
  Future<Result<ProfileModel>> updateProfile(ProfileModel profile) async {
    await Future.delayed(const Duration(seconds: 1));

    // Update the mock profile
    _mockProfile = profile.copyWith(updatedAt: DateTime.now()) as ProfileModel;

    return Success(_mockProfile!);
  }

  @override
  Future<Result<void>> deleteProfile(String userId) async {
    await Future.delayed(const Duration(seconds: 1));

    // Clear the mock profile
    _mockProfile = null;

    return const Success(null);
  }

  @override
  Future<Result<void>> uploadProfileImage(
    String userId,
    String imagePath,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock image upload - in real app, this would upload to storage
    // and update the profile with the new image URL

    return const Success(null);
  }
}
