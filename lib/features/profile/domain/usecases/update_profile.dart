import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repo.dart';

class UpdateProfileParams {
  final ProfileEntity profile;

  const UpdateProfileParams({required this.profile});
}

class UpdateProfile implements UseCase<ProfileEntity, UpdateProfileParams> {
  final ProfileRepo repository;

  const UpdateProfile(this.repository);

  @override
  Future<Result<ProfileEntity>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(params.profile);
  }
}
