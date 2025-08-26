import '../../../../core/utils/result.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepo {
  Future<Result<List<CartItemEntity>>> getCart();
  Future<Result<CartItemEntity>> addToCart(String productId, int quantity);
  Future<Result<void>> removeFromCart(String cartItemId);
  Future<Result<void>> updateCartItem(String cartItemId, int quantity);
  Future<Result<void>> clearCart();
  Future<Result<double>> getCartTotal();
  Future<Result<int>> getCartItemCount();
}
