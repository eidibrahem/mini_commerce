import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepo {
  Future<Result<UserEntity>> signInWithEmail(String email, String password);
  Future<Result<UserEntity>> signInWithGoogle();
  Future<Result<UserEntity>> signUp(String email, String password, String name);
  Future<Result<void>> signOut();
  Future<Result<UserEntity?>> getCurrentUser();
  Future<Result<void>> sendPasswordResetEmail(String email);
  Future<Result<void>> updateProfile(String name, String? photoUrl);
}
