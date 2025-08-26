import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repo.dart';

class GetProfileParams {
  final String userId;

  const GetProfileParams({required this.userId});
}

class GetProfile implements UseCase<ProfileEntity, GetProfileParams> {
  final ProfileRepo repository;

  const GetProfile(this.repository);

  @override
  Future<Result<ProfileEntity>> call(GetProfileParams params) async {
    return await repository.getProfile(params.userId);
  }
}
