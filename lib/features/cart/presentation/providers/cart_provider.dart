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
  String? _userId;

  List<CartItemEntity> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get itemCount => _cartItems.length;
  String? get userId => _userId;

  double get totalAmount {
    return _cartItems.fold(0.0, (total, item) => total + item.totalPrice);
  }

  void setUserId(String userId) {
    _userId = userId;
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
    if (_userId == null) {
      _setError('User ID not set');
      print('❌ CartProvider: Cannot load cart - User ID not set');
      return;
    }

    print('🔄 CartProvider: Loading cart for user: $_userId');
    _setLoading(true);
    _setError(null);

    try {
      final result = await getCart(GetCartParams(userId: _userId!));

      result.when(
        success: (items) {
          print(
            '✅ CartProvider: Cart loaded successfully - ${items.length} items',
          );
          _setCartItems(items);
          _setError(null);
        },
        failure: (failure) {
          print('❌ CartProvider: Failed to load cart - ${failure.message}');
          _setError('Failed to load cart');
          _setCartItems([]);
        },
      );
    } catch (e) {
      print('❌ CartProvider: Unexpected error loading cart - $e');
      _setError('An unexpected error occurred');
      _setCartItems([]);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addItemToCart(String productId, int quantity) async {
    if (_userId == null) {
      _setError('User ID not set');
      print('❌ CartProvider: User ID not set');
      return;
    }

    print(
      '🛒 CartProvider: Adding item to cart - ProductID: $productId, Quantity: $quantity, UserID: $_userId',
    );
    _setLoading(true);
    _setError(null);

    try {
      final result = await addToCart(
        AddToCartParams(
          userId: _userId!,
          productId: productId,
          quantity: quantity,
        ),
      );

      result.when(
        success: (item) {
          print(
            '✅ CartProvider: Item added successfully - ${item.product.name}',
          );
          // Reload cart to get updated state
          loadCart();
        },
        failure: (failure) {
          print('❌ CartProvider: Failed to add item - ${failure.message}');
          _setError('Failed to add item to cart: ${failure.message}');
        },
      );
    } catch (e) {
      print('❌ CartProvider: Unexpected error - $e');
      _setError('An unexpected error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeItemFromCart(String cartItemId) async {
    if (_userId == null) {
      _setError('User ID not set');
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
      final result = await removeFromCart(
        RemoveFromCartParams(userId: _userId!, cartItemId: cartItemId),
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
    if (_userId == null) {
      _setError('User ID not set');
      return;
    }

    if (quantity <= 0) {
      await removeItemFromCart(cartItemId);
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
      final result = await updateCartItem(
        UpdateCartItemParams(
          userId: _userId!,
          cartItemId: cartItemId,
          quantity: quantity,
        ),
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

  Future<void> clearCart() async {
    if (_userId == null) {
      _setError('User ID not set');
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
      // For now, we'll remove items one by one since we don't have a clear cart use case
      // In a real app, you'd want to add a ClearCart use case
      for (final item in _cartItems) {
        await removeFromCart(
          RemoveFromCartParams(userId: _userId!, cartItemId: item.id),
        );
      }

      _setCartItems([]);
      _setError(null);
    } catch (e) {
      _setError('Failed to clear cart');
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
              category: '',
              name: '',
              reviewCount: 0,
              isAvailable: false,
              stockQuantity: 0,
              tags: [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
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
