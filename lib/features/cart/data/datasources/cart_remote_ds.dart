import '../../../../core/utils/result.dart';
import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<Result<List<CartItemModel>>> getCart(String userId);
  Future<Result<CartItemModel>> addToCart(
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
