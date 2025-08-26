import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repo.dart';

class SignInGoogle implements UseCase<UserEntity, NoParams> {
  final AuthRepo repository;

  const SignInGoogle(this.repository);

  @override
  Future<Result<UserEntity>> call(NoParams params) async {
    return await repository.signInWithGoogle();
  }
}
