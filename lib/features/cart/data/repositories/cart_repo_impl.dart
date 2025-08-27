import '../../../../core/utils/result.dart';
import '../../../../core/error/failures.dart' as failures;
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repo.dart';
import '../datasources/cart_remote_ds.dart';
import '../models/cart_item_model.dart';

class CartRepoImpl implements CartRepo {
  final CartRemoteDataSource remoteDataSource;

  const CartRepoImpl({required this.remoteDataSource});

  @override
  Future<Result<List<CartItemEntity>>> getCart(String userId) async {
    try {
      final result = await remoteDataSource.getCart(userId);
      return result.map(
        (cartItemModels) =>
            cartItemModels.map((model) => model as CartItemEntity).toList(),
      );
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to get cart'));
    }
  }

  @override
  Future<Result<CartItemEntity>> addToCart(
    String userId,
    String productId,
    int quantity,
  ) async {
    try {
      final result = await remoteDataSource.addToCart(
        userId,
        productId,
        quantity,
      );
      return result.map((cartItemModel) => cartItemModel as CartItemEntity);
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to add to cart'));
    }
  }

  @override
  Future<Result<void>> removeFromCart(String userId, String cartItemId) async {
    try {
      return await remoteDataSource.removeFromCart(userId, cartItemId);
    } catch (e) {
      return FailureResult(
        failures.UnknownFailure('Failed to remove from cart'),
      );
    }
  }

  @override
  Future<Result<void>> updateCartItem(
    String userId,
    String cartItemId,
    int quantity,
  ) async {
    try {
      return await remoteDataSource.updateCartItem(
        userId,
        cartItemId,
        quantity,
      );
    } catch (e) {
      return FailureResult(
        failures.UnknownFailure('Failed to update cart item'),
      );
    }
  }

  @override
  Future<Result<void>> clearCart(String userId) async {
    try {
      return await remoteDataSource.clearCart(userId);
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to clear cart'));
    }
  }

  @override
  Future<Result<double>> getCartTotal(String userId) async {
    try {
      return await remoteDataSource.getCartTotal(userId);
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to get cart total'));
    }
  }

  @override
  Future<Result<int>> getCartItemCount(String userId) async {
    try {
      return await remoteDataSource.getCartItemCount(userId);
    } catch (e) {
      return FailureResult(
        failures.UnknownFailure('Failed to get cart item count'),
      );
    }
  }
}
