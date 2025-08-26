import 'package:flutter/foundation.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/usecases/get_cart.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/remove_from_cart.dart';
import '../../domain/usecases/update_cart_item.dart';

class CartProvider extends ChangeNotifier {
  final GetCart getCart;
  final AddToCart addToCart;
  final RemoveFromCart removeFromCart;
  final UpdateCartItem updateCartItem;

  CartProvider({
    required this.getCart,
    required this.addToCart,
    required this.removeFromCart,
    required this.updateCartItem,
  });

  List<CartItemEntity> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CartItemEntity> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get itemCount => _cartItems.length;

  double get totalAmount {
    return _cartItems.fold(0.0, (total, item) => total + item.totalPrice);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setCartItems(List<CartItemEntity> items) {
    _cartItems = items;
    notifyListeners();
  }

  Future<void> loadCart() async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await getCart(NoParams());

      result.when(
        success: (items) {
          _setCartItems(items);
          _setError(null);
        },
        failure: (failure) {
          _setError('Failed to load cart');
          _setCartItems([]);
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred');
      _setCartItems([]);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addItemToCart(String productId, int quantity) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await addToCart(
        AddToCartParams(productId: productId, quantity: quantity),
      );

      result.when(
        success: (item) {
          // Reload cart to get updated state
          loadCart();
        },
        failure: (failure) {
          _setError('Failed to add item to cart');
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeItemFromCart(String cartItemId) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await removeFromCart(
        RemoveFromCartParams(cartItemId: cartItemId),
      );

      result.when(
        success: (_) {
          // Reload cart to get updated state
          loadCart();
        },
        failure: (failure) {
          _setError('Failed to remove item from cart');
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateItemQuantity(String cartItemId, int quantity) async {
    if (quantity <= 0) {
      await removeItemFromCart(cartItemId);
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
      final result = await updateCartItem(
        UpdateCartItemParams(cartItemId: cartItemId, quantity: quantity),
      );

      result.when(
        success: (_) {
          // Reload cart to get updated state
          loadCart();
        },
        failure: (failure) {
          _setError('Failed to update item quantity');
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred');
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _setError(null);
  }

  bool isInCart(String productId) {
    return _cartItems.any((item) => item.product.id == productId);
  }

  int getItemQuantity(String productId) {
    final item = _cartItems.firstWhere(
      (item) => item.product.id == productId,
      orElse:
          () => CartItemEntity(
            id: '',
            product: ProductEntity(
              id: '',
              name: '',
              description: '',
              price: 0.0,
              imageUrl: '',

              rating: 0.0,
            ),
            quantity: 0,
            addedAt: DateTime.now(),
          ),
    );
    return item.quantity;
  }
}
