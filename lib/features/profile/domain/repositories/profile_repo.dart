import '../../../../core/utils/result.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepo {
  Future<Result<ProfileEntity>> getProfile(String userId);
  Future<Result<ProfileEntity>> updateProfile(ProfileEntity profile);
  Future<Result<void>> deleteProfile(String userId);
  Future<Result<void>> uploadProfileImage(String userId, String imagePath);
}
