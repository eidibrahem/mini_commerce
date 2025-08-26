import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repo.dart';

class SignUpParams {
  final String email;
  final String password;
  final String name;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}

class SignUp implements UseCase<UserEntity, SignUpParams> {
  final AuthRepo repository;

  const SignUp(this.repository);

  @override
  Future<Result<UserEntity>> call(SignUpParams params) async {
    return await repository.signUp(params.email, params.password, params.name);
  }
}
