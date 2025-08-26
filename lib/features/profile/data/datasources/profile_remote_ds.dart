import '../../../../core/utils/result.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<Result<ProfileModel>> getProfile(String userId);
  Future<Result<ProfileModel>> updateProfile(ProfileModel profile);
  Future<Result<void>> deleteProfile(String userId);
  Future<Result<void>> uploadProfileImage(String userId, String imagePath);
}
