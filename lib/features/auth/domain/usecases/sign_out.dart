import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repo.dart';

class SignOut implements UseCase<void, NoParams> {
  final AuthRepo repository;

  const SignOut(this.repository);

  @override
  Future<Result<void>> call(NoParams params) async {
    return await repository.signOut();
  }
}
