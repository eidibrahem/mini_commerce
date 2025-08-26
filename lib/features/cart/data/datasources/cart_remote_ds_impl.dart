import '../../../../core/utils/result.dart';
import '../models/cart_item_model.dart';
import 'cart_remote_ds.dart';
import '../../../products/domain/entities/product_entity.dart';

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final List<CartItemModel> _mockCart = [];

  @override
  Future<Result<List<CartItemModel>>> getCart() async {
    await Future.delayed(const Duration(seconds: 1));
    return Success(_mockCart);
  }

  @override
  Future<Result<CartItemModel>> addToCart(
    String productId,
    int quantity,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    // For mock implementation, we'll create a simple product entity
    // In real app, you'd fetch the product from repository
    final mockProduct = ProductEntity(
      id: productId,
      name: 'Product $productId',
      description: 'Mock product description',
      price: 99.99,
      imageUrl: 'https://example.com/product.jpg',
      rating: 4.5,
    );

    // Check if product already exists in cart
    final existingIndex = _mockCart.indexWhere(
      (item) => item.product.id == productId,
    );

    if (existingIndex != -1) {
      // Update quantity if product exists
      _mockCart[existingIndex] =
          _mockCart[existingIndex].copyWith(
                quantity: _mockCart[existingIndex].quantity + quantity,
              )
              as CartItemModel;
      return Success(_mockCart[existingIndex]);
    } else {
      // Add new item to cart
      final cartItem = CartItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: mockProduct,
        quantity: quantity,
        addedAt: DateTime.now(),
      );
      _mockCart.add(cartItem);
      return Success(cartItem);
    }
  }

  @override
  Future<Result<void>> removeFromCart(String cartItemId) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockCart.removeWhere((item) => item.id == cartItemId);
    return const Success(null);
  }

  @override
  Future<Result<void>> updateCartItem(String cartItemId, int quantity) async {
    await Future.delayed(const Duration(seconds: 1));

    final index = _mockCart.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      if (quantity <= 0) {
        _mockCart.removeAt(index);
      } else {
        _mockCart[index] =
            _mockCart[index].copyWith(quantity: quantity) as CartItemModel;
      }
    }

    return const Success(null);
  }

  @override
  Future<Result<void>> clearCart() async {
    await Future.delayed(const Duration(seconds: 1));
    _mockCart.clear();
    return const Success(null);
  }

  @override
  Future<Result<double>> getCartTotal() async {
    await Future.delayed(const Duration(seconds: 1));
    final total = _mockCart.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
    return Success(total);
  }

  @override
  Future<Result<int>> getCartItemCount() async {
    await Future.delayed(const Duration(seconds: 1));
    final count = _mockCart.fold<int>(0, (sum, item) => sum + item.quantity);
    return Success(count);
  }
}
