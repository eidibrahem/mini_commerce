import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repo.dart';

class SignInEmailParams {
  final String email;
  final String password;

  const SignInEmailParams({required this.email, required this.password});
}

class SignInEmail implements UseCase<UserEntity, SignInEmailParams> {
  final AuthRepo repository;

  const SignInEmail(this.repository);

  @override
  Future<Result<UserEntity>> call(SignInEmailParams params) async {
    return await repository.signInWithEmail(params.email, params.password);
  }
}
