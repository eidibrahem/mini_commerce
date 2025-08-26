import '../../../../core/utils/result.dart';
import '../../../../core/error/failures.dart' as failures;
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repo.dart';
import '../datasources/auth_remote_ds.dart';
import '../models/user_model.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepoImpl({required this.remoteDataSource});

  @override
  Future<Result<UserEntity>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final result = await remoteDataSource.signInWithEmail(email, password);
      return result.map((userModel) => userModel as UserEntity);
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to sign in with email'));
    }
  }

  @override
  Future<Result<UserEntity>> signInWithGoogle() async {
    try {
      final result = await remoteDataSource.signInWithGoogle();
      return result.map((userModel) => userModel as UserEntity);
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to sign in with Google'));
    }
  }

  @override
  Future<Result<UserEntity>> signUp(
    String email,
    String password,
    String name,
  ) async {
    try {
      final result = await remoteDataSource.signUp(email, password, name);
      return result.map((userModel) => userModel as UserEntity);
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to sign up'));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      return await remoteDataSource.signOut();
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to sign out'));
    }
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    try {
      final result = await remoteDataSource.getCurrentUser();
      return result.map((userModel) => userModel as UserEntity?);
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to get current user'));
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      return await remoteDataSource.sendPasswordResetEmail(email);
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to send password reset email'));
    }
  }

  @override
  Future<Result<void>> updateProfile(String name, String? photoUrl) async {
    try {
      return await remoteDataSource.updateProfile(name, photoUrl);
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to update profile'));
    }
  }
}
