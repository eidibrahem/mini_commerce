import '../../../../core/utils/result.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Result<UserModel>> signInWithEmail(String email, String password);
  Future<Result<UserModel>> signInWithGoogle();
  Future<Result<UserModel>> signUp(String email, String password, String name);
  Future<Result<void>> signOut();
  Future<Result<UserModel?>> getCurrentUser();
  Future<Result<void>> sendPasswordResetEmail(String email);
  Future<Result<void>> updateProfile(String name, String? photoUrl);
}
