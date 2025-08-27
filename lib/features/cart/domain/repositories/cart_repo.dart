import '../../../../core/utils/result.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepo {
  Future<Result<List<CartItemEntity>>> getCart(String userId);
  Future<Result<CartItemEntity>> addToCart(
    String userId,
    String productId,
    int quantity,
  );
  Future<Result<void>> removeFromCart(String userId, String cartItemId);
  Future<Result<void>> updateCartItem(
    String userId,
    String cartItemId,
    int quantity,
  );
  Future<Result<void>> clearCart(String userId);
  Future<Result<double>> getCartTotal(String userId);
  Future<Result<int>> getCartItemCount(String userId);
}
