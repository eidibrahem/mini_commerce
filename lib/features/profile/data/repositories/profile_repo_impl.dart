import '../../../../core/utils/result.dart';
import '../../../../core/error/failures.dart' as failures;
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repo.dart';
import '../datasources/profile_remote_ds.dart';
import '../models/profile_model.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;

  const ProfileRepoImpl({required this.remoteDataSource});

  @override
  Future<Result<ProfileEntity>> getProfile(String userId) async {
    try {
      final result = await remoteDataSource.getProfile(userId);
      return result.map((profileModel) => profileModel as ProfileEntity);
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to get profile'));
    }
  }

  @override
  Future<Result<ProfileEntity>> updateProfile(ProfileEntity profile) async {
    try {
      final result = await remoteDataSource.updateProfile(
        ProfileModel.fromEntity(profile),
      );
      return result.map((profileModel) => profileModel as ProfileEntity);
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to update profile'));
    }
  }

  @override
  Future<Result<void>> deleteProfile(String userId) async {
    try {
      return await remoteDataSource.deleteProfile(userId);
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to delete profile'));
    }
  }

  @override
  Future<Result<void>> uploadProfileImage(
    String userId,
    String imagePath,
  ) async {
    try {
      return await remoteDataSource.uploadProfileImage(userId, imagePath);
    } catch (e) {
      return FailureResult(
        failures.UnknownFailure('Failed to upload profile image'),
      );
    }
  }
}
