import 'package:get_it/get_it.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mini_commerce/features/auth/presentation/providers/auth_provider.dart';

import '../../features/auth/data/datasources/auth_remote_ds.dart';
import '../../features/auth/data/repositories/auth_repo_impl.dart';
import '../../features/auth/data/datasources/auth_remote_ds_impl.dart';
import '../../features/auth/domain/repositories/auth_repo.dart';
import '../../features/auth/domain/usecases/sign_in_email.dart';
import '../../features/auth/domain/usecases/sign_in_google.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/cart/data/datasources/cart_remote_ds.dart';
import '../../features/cart/data/datasources/cart_remote_ds_impl.dart';
import '../../features/products/data/datasources/product_remote_ds.dart';
import '../../features/products/data/datasources/product_remote_ds_impl.dart';
import '../../features/products/data/repositories/product_repo_impl.dart';
import '../../features/products/domain/repositories/product_repo.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/presentation/providers/product_provider.dart';
import '../../features/cart/data/repositories/cart_repo_impl.dart';
import '../../features/cart/domain/repositories/cart_repo.dart';
import '../../features/cart/domain/usecases/add_to_cart.dart';
import '../../features/cart/domain/usecases/get_cart.dart';
import '../../features/cart/domain/usecases/remove_from_cart.dart';
import '../../features/cart/domain/usecases/update_cart_item.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/profile/data/datasources/profile_remote_ds.dart';
import '../../features/profile/data/datasources/profile_remote_ds_impl.dart';
import '../../features/profile/data/repositories/profile_repo_impl.dart';
import '../../features/profile/domain/repositories/profile_repo.dart';
import '../../features/profile/domain/usecases/get_profile.dart';
import '../../features/profile/domain/usecases/update_profile.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Register mock data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: firebase_auth.FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      googleSignIn: GoogleSignIn(),
    ),
  );
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );

  // Auth Feature
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton(() => SignInEmail(getIt()));
  getIt.registerLazySingleton(() => SignInGoogle(getIt()));
  getIt.registerLazySingleton(() => SignUp(getIt()));
  getIt.registerLazySingleton(() => SignOut(getIt()));
  getIt.registerLazySingleton(
    () => AuthProvider(
      signInEmail: getIt(),
      signInGoogle: getIt(),
      signUp: getIt(),
      signOut: getIt(),
    ),
  );

  // Products Feature
  getIt.registerLazySingleton<ProductRepo>(
    () => ProductRepoImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton(() => GetProducts(getIt()));
  getIt.registerLazySingleton(() => ProductProvider(getIt()));

  // Cart Feature
  getIt.registerLazySingleton<CartRepo>(
    () => CartRepoImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton(() => GetCart(getIt()));
  getIt.registerLazySingleton(() => AddToCart(getIt()));
  getIt.registerLazySingleton(() => RemoveFromCart(getIt()));
  getIt.registerLazySingleton(() => UpdateCartItem(getIt()));
  getIt.registerLazySingleton(
    () => CartProvider(
      getCart: getIt(),
      addToCart: getIt(),
      removeFromCart: getIt(),
      updateCartItem: getIt(),
    ),
  );

  // Profile Feature
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton(() => GetProfile(getIt()));
  getIt.registerLazySingleton(() => UpdateProfile(getIt()));
  getIt.registerLazySingleton(
    () => ProfileProvider(getProfile: getIt(), updateProfile: getIt()),
  );
}
