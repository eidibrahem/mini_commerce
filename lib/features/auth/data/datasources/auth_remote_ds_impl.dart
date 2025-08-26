import '../../../../core/utils/result.dart';
import '../../../../core/error/failures.dart' as failures;
import '../models/user_model.dart';
import 'auth_remote_ds.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/utils/cache_helper.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    GoogleSignIn? googleSignIn,
  }) : _auth = firebaseAuth,
       _firestore = firestore,
       _googleSignIn = googleSignIn ?? GoogleSignIn();
  @override
  Future<Result<UserModel>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      // Sign in with Firebase Auth
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return FailureResult(failures.AuthFailure('Failed to sign in'));
      }

      // Get user data from Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        return FailureResult(
          failures.NotFoundFailure('User profile not found'),
        );
      }

      final userData = userDoc.data()!;
      final userModel = UserModel.fromJson(userData);
      CacheHelper.saveData(key: 'uId', value: userCredential.user?.uid);
      return Success(userModel);
    } catch (e) {
      if (e is firebase_auth.FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            return FailureResult(
              failures.AuthFailure('No user found with this email'),
            );
          case 'wrong-password':
            return FailureResult(failures.AuthFailure('Wrong password'));
          case 'invalid-email':
            return FailureResult(failures.AuthFailure('Invalid email address'));
          case 'user-disabled':
            return FailureResult(
              failures.AuthFailure('User account has been disabled'),
            );
          default:
            return FailureResult(
              failures.AuthFailure(e.message ?? 'Authentication failed'),
            );
        }
      }
      return FailureResult(
        failures.UnknownFailure('Failed to sign in: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<UserModel>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return FailureResult(
          failures.AuthFailure('Google Sign-In was cancelled'),
        );
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        return FailureResult(
          failures.AuthFailure('Failed to sign in with Google'),
        );
      }

      // Create user document in Firestore if it doesn't exist
      final userModel = UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'Google User',
        photoUrl: user.photoURL,
        isEmailVerified: user.emailVerified,
        createdAt: DateTime.now(),
        lastSignInAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson(), SetOptions(merge: true));
      CacheHelper.saveData(key: 'uId', value: userCredential.user?.uid);
      return Success(userModel);
    } catch (e) {
      if (e is firebase_auth.FirebaseAuthException) {
        switch (e.code) {
          case 'account-exists-with-different-credential':
            return FailureResult(
              failures.AuthFailure(
                'An account already exists with the same email address but different sign-in credentials',
              ),
            );
          case 'invalid-credential':
            return FailureResult(
              failures.AuthFailure('Invalid Google Sign-In credentials'),
            );
          case 'operation-not-allowed':
            return FailureResult(
              failures.AuthFailure(
                'Google Sign-In is not enabled for this project',
              ),
            );
          default:
            return FailureResult(
              failures.AuthFailure(e.message ?? 'Google Sign-In failed'),
            );
        }
      }
      return FailureResult(
        failures.UnknownFailure(
          'Failed to sign in with Google: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<UserModel>> signUp(
    String email,
    String password,
    String name,
  ) async {
    try {
      // Create user with Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return FailureResult(failures.AuthFailure('Failed to create user'));
      }

      // Create user document in Firestore
      final userModel = UserModel(
        id: user.uid,
        email: email,
        name: name,
        photoUrl: null,
        isEmailVerified: user.emailVerified,
        createdAt: DateTime.now(),
        lastSignInAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson());
      CacheHelper.saveData(key: 'uId', value: userCredential.user?.uid);
      return Success(userModel);
    } catch (e) {
      if (e is firebase_auth.FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            return FailureResult(
              failures.AuthFailure('Email is already in use'),
            );
          case 'weak-password':
            return FailureResult(failures.AuthFailure('Password is too weak'));
          case 'invalid-email':
            return FailureResult(failures.AuthFailure('Invalid email address'));
          default:
            return FailureResult(
              failures.AuthFailure(e.message ?? 'Authentication failed'),
            );
        }
      }
      return FailureResult(
        failures.UnknownFailure('Failed to sign up: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _auth.signOut();
      return const Success(null);
    } catch (e) {
      return FailureResult(
        failures.AuthFailure('Failed to sign out: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<UserModel?>> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const Success(null);
      }

      // Get user data from Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        return const Success(null);
      }

      final userData = userDoc.data()!;
      final userModel = UserModel.fromJson(userData);

      return Success(userModel);
    } catch (e) {
      return FailureResult(
        failures.UnknownFailure('Failed to get current user: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Success(null);
    } catch (e) {
      if (e is firebase_auth.FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            return FailureResult(
              failures.AuthFailure('No user found with this email'),
            );
          case 'invalid-email':
            return FailureResult(failures.AuthFailure('Invalid email address'));
          default:
            return FailureResult(
              failures.AuthFailure(
                e.message ?? 'Failed to send password reset email',
              ),
            );
        }
      }
      return FailureResult(
        failures.UnknownFailure(
          'Failed to send password reset email: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<void>> updateProfile(String name, String? photoUrl) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return FailureResult(
          failures.AuthFailure('No user is currently signed in'),
        );
      }

      // Update user profile in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'name': name,
        if (photoUrl != null) 'photoUrl': photoUrl,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      return const Success(null);
    } catch (e) {
      return FailureResult(
        failures.UnknownFailure('Failed to update profile: ${e.toString()}'),
      );
    }
  }
}
