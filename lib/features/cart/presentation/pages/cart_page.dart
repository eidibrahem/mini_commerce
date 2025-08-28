import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants.dart';
import '../../../../core/utils/cache_helper.dart';
import '../providers/cart_provider.dart';
import 'st_ser.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isProcessingCheckout = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('🛒 CartPage: initState - Starting cart initialization');
      final userId = await CacheHelper.getData(key: 'uId');
      print('🛒 CartPage: Retrieved userId: $userId');
      if (userId != null) {
        print('🛒 CartPage: Setting userId in CartProvider');
        context.read<CartProvider>().setUserId(userId);
        print('🛒 CartPage: Loading cart...');
        await context.read<CartProvider>().loadCart();
        print('🛒 CartPage: Cart loading completed');
      } else {
        print('❌ CartPage: No userId found - cannot load cart');
      }
    });
  }

  /// Process checkout with Stripe Payment Sheet
  Future<void> _processCheckout(
    BuildContext context,
    CartProvider cartProvider,
  ) async {
    try {
      setState(() {
        _isProcessingCheckout = true;
      });

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppConstants.primaryColor,
                ),
              ),
            ),
      );

      // Get user ID
      final userId = await CacheHelper.getData(key: 'uId');
      if (userId == null) {
        Navigator.pop(context); // Close loading dialog
        _showErrorSnackBar('User not authenticated');
        return;
      }

      // Log cart data for debugging
      print('🛒 CartPage: Cart data for checkout:');
      print('   Total Amount: \$${cartProvider.totalAmount}');
      print('   Item Count: ${cartProvider.itemCount}');
      print('   Items:');
      for (final item in cartProvider.cartItems) {
        print(
          '     - ${item.product.name} x${item.quantity} = \$${(item.product.price * item.quantity).toStringAsFixed(2)}',
        );
      }

      Navigator.pop(context); // Close loading dialog

      // Use PaymentManager to process payment with Stripe Payment Sheet
      await PaymentManager.makePayment(
        cartProvider.totalAmount.round(),
        "USD", // Using USD instead of EGP for consistency
      );

      // If we reach here, payment was successful
      _showSuccessSnackBar(
        'Payment successful! Order confirmed for \$${cartProvider.totalAmount.toStringAsFixed(2)}',
      );

      // Clear cart after successful payment
      await cartProvider.clearCart();

      // Wait a moment for user to see success message, then navigate back
      await Future.delayed(const Duration(seconds: 2));

      // Navigate back to previous screen
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorSnackBar('Payment failed: $e');
      print('❌ CartPage: Payment error: $e');
    } finally {
      setState(() {
        _isProcessingCheckout = false;
      });
    }
  }

  /// Show success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message, style: const TextStyle(fontSize: 16)),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
    );
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Text(message, style: const TextStyle(fontSize: 16)),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🛒 Shopping Cart',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () async {
              print('🔄 CartPage: Manual refresh requested');
              final userId = await CacheHelper.getData(key: 'uId');
              if (userId != null) {
                context.read<CartProvider>().setUserId(userId);
                await context.read<CartProvider>().loadCart();
              }
            },
            tooltip: 'Refresh Cart',
          ),
          // Clear cart button
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              if (cartProvider.cartItems.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep_rounded),
                  onPressed: () {
                    _showClearCartDialog(context, cartProvider);
                  },
                  tooltip: 'Clear All Items',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Text(
                    'Loading your cart...',
                    style: AppConstants.bodyStyle.copyWith(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          if (cartProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 80,
                    color: AppConstants.errorColor,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Text(
                    'Oops! Something went wrong',
                    style: AppConstants.headingStyle.copyWith(
                      color: AppConstants.errorColor,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    cartProvider.errorMessage!,
                    style: AppConstants.bodyStyle.copyWith(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                  ElevatedButton.icon(
                    onPressed: () {
                      cartProvider.loadCart();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingLarge,
                        vertical: AppConstants.paddingMedium,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (cartProvider.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                  Text(
                    'Your cart is empty',
                    style: AppConstants.headingStyle.copyWith(
                      color: Colors.grey[700],
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Text(
                    'Looks like you haven\'t added any items yet.\nStart shopping to fill your cart!',
                    style: AppConstants.bodyStyle.copyWith(
                      color: Colors.grey[600],
                      fontSize: 16,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Debug info
                  if (kDebugMode) ...[
                    const SizedBox(height: AppConstants.paddingMedium),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium,
                        ),
                        border: Border.all(
                          color: Colors.grey[300] ?? Colors.grey,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '🐛 Debug Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'User ID: ${cartProvider.userId ?? 'Not set'}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Error: ${cartProvider.errorMessage ?? 'None'}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Loading: ${cartProvider.isLoading}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppConstants.paddingLarge),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/products');
                    },
                    icon: const Icon(Icons.shopping_bag_rounded),
                    label: const Text(
                      'Start Shopping',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingLarge,
                        vertical: AppConstants.paddingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Cart Items List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  itemCount: cartProvider.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartProvider.cartItems[index];
                    return _buildCartItemCard(context, cartItem, cartProvider);
                  },
                ),
              ),

              // Cart Summary
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.borderRadiusLarge),
                    topRight: Radius.circular(AppConstants.borderRadiusLarge),
                  ),
                ),
                child: Column(
                  children: [
                    // Summary Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Summary',
                              style: AppConstants.bodyStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              '${cartProvider.itemCount} ${cartProvider.itemCount == 1 ? 'item' : 'items'}',
                              style: AppConstants.bodyStyle.copyWith(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Total Amount',
                              style: AppConstants.bodyStyle.copyWith(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                              style: AppConstants.headingStyle.copyWith(
                                color: AppConstants.primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),

                    // Payment Summary
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusSmall,
                        ),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total to Pay:',
                            style: AppConstants.bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                            style: AppConstants.headingStyle.copyWith(
                              color: AppConstants.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingMedium),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            (cartProvider.cartItems.isNotEmpty &&
                                    !_isProcessingCheckout)
                                ? () => _processCheckout(context, cartProvider)
                                : null,
                        icon:
                            _isProcessingCheckout
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Icon(Icons.payment_rounded),
                        label: Text(
                          _isProcessingCheckout
                              ? 'Processing...'
                              : 'Proceed to Checkout',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.paddingLarge,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItemCard(
    BuildContext context,
    cartItem,
    CartProvider cartProvider,
  ) {
    final radiusM = AppConstants.borderRadiusMedium;
    final radiusS = AppConstants.borderRadiusSmall;
    final theme = Theme.of(context);

    // Optional: swipe to remove
    return Dismissible(
      key: ValueKey('cart:${cartItem.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(radiusM),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        final should = await showDialog<bool>(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Remove item'),
                content: Text('Remove "${cartItem.product.name}" from cart?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Remove'),
                  ),
                ],
              ),
        );
        return should ?? false;
      },
      onDismissed: (_) => cartProvider.removeItemFromCart(cartItem.id),

      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radiusM),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Image thumb ----
              ClipRRect(
                borderRadius: BorderRadius.circular(radiusM),
                child: Image.network(
                  cartItem.product.imageUrl,
                  width: 76,
                  height: 76,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        width: 76,
                        height: 76,
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey[400],
                        ),
                      ),
                  loadingBuilder:
                      (c, child, prog) =>
                          prog == null
                              ? child
                              : Container(
                                width: 76,
                                height: 76,
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                child: const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),

              // ---- Title / meta / price ----
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + remove (overflow-safe row)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            cartItem.product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[850],
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Tooltip(
                              message: 'Remove item',
                              child: InkWell(
                                onTap:
                                    () => cartProvider.removeItemFromCart(
                                      cartItem.id,
                                    ),
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusSmall,
                                ),
                                child: SizedBox.square(
                                  dimension:
                                      32, // tighter than IconButton’s default 48
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      borderRadius: BorderRadius.circular(
                                        AppConstants.borderRadiusSmall,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.delete_outline_rounded,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Category chip + Unit price
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(radiusS),
                          ),
                          child: Text(
                            cartItem.product.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Text(
                          'Unit: \$${cartItem.product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Quantity stepper + total (resilient row)
                    Row(
                      children: [
                        _qtyButton(
                          icon: Icons.remove_rounded,
                          onTap:
                              () =>
                                  cartItem.quantity > 1
                                      ? cartProvider.updateItemQuantity(
                                        cartItem.id,
                                        cartItem.quantity - 1,
                                      )
                                      : cartProvider.removeItemFromCart(
                                        cartItem.id,
                                      ),
                          bg: Colors.grey[100],
                          fg: Colors.grey[900],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(radiusS),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            '${cartItem.quantity}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        _qtyButton(
                          icon: Icons.add_rounded,
                          onTap:
                              () => cartProvider.updateItemQuantity(
                                cartItem.id,
                                cartItem.quantity + 1,
                              ),
                          bg: AppConstants.primaryColor.withOpacity(0.12),
                          fg: AppConstants.primaryColor,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qtyButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? bg,
    Color? fg,
  }) {
    return Material(
      color: bg ?? Colors.grey[100],
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 18, color: fg ?? Colors.black87),
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text(
            'Are you sure you want to remove all items from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await cartProvider.clearCart();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cart cleared successfully!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}
