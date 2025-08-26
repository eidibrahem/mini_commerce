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
  Future<Result<List<CartItemEntity>>> getCart() async {
    try {
      final result = await remoteDataSource.getCart();
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
    String productId,
    int quantity,
  ) async {
    try {
      final result = await remoteDataSource.addToCart(productId, quantity);
      return result.map((cartItemModel) => cartItemModel as CartItemEntity);
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to add to cart'));
    }
  }

  @override
  Future<Result<void>> removeFromCart(String cartItemId) async {
    try {
      return await remoteDataSource.removeFromCart(cartItemId);
    } catch (e) {
      return FailureResult(
        failures.UnknownFailure('Failed to remove from cart'),
      );
    }
  }

  @override
  Future<Result<void>> updateCartItem(String cartItemId, int quantity) async {
    try {
      return await remoteDataSource.updateCartItem(cartItemId, quantity);
    } catch (e) {
      return FailureResult(
        failures.UnknownFailure('Failed to update cart item'),
      );
    }
  }

  @override
  Future<Result<void>> clearCart() async {
    try {
      return await remoteDataSource.clearCart();
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to clear cart'));
    }
  }

  @override
  Future<Result<double>> getCartTotal() async {
    try {
      return await remoteDataSource.getCartTotal();
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to get cart total'));
    }
  }

  @override
  Future<Result<int>> getCartItemCount() async {
    try {
      return await remoteDataSource.getCartItemCount();
    } catch (e) {
      return FailureResult(
        failures.UnknownFailure('Failed to get cart item count'),
      );
    }
  }
}
