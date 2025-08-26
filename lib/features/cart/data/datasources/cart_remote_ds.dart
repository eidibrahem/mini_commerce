import '../../../../core/utils/result.dart';
import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<Result<List<CartItemModel>>> getCart();
  Future<Result<CartItemModel>> addToCart(String productId, int quantity);
  Future<Result<void>> removeFromCart(String cartItemId);
  Future<Result<void>> updateCartItem(String cartItemId, int quantity);
  Future<Result<void>> clearCart();
  Future<Result<double>> getCartTotal();
  Future<Result<int>> getCartItemCount();
}
