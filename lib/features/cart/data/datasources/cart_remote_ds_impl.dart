import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/error/failures.dart' as failures;
import '../models/cart_item_model.dart';
import 'cart_remote_ds.dart';
import '../../../products/domain/entities/product_entity.dart';

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<List<CartItemModel>>> getCart(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cart')
              .get();

      final cartItems =
          querySnapshot.docs.map((doc) {
            final data = doc.data();
            return CartItemModel(
              id: doc.id,
              product: ProductEntity(
                id: data['productId'] ?? '',
                name: data['productName'] ?? '',
                description: data['productDescription'] ?? '',
                price: (data['productPrice'] as num?)?.toDouble() ?? 0.0,
                imageUrl: data['productImageUrl'] ?? '',
                category: data['productCategory'] ?? '',
                rating: (data['productRating'] as num?)?.toDouble() ?? 0.0,
                reviewCount: data['productReviewCount'] ?? 0,
                isAvailable: data['productIsAvailable'] ?? true,
                stockQuantity: data['productStockQuantity'] ?? 0,
                tags: List<String>.from(data['productTags'] ?? []),
                createdAt:
                    data['productCreatedAt'] != null
                        ? (data['productCreatedAt'] as Timestamp).toDate()
                        : DateTime.now(),
                updatedAt:
                    data['productUpdatedAt'] != null
                        ? (data['productUpdatedAt'] as Timestamp).toDate()
                        : DateTime.now(),
              ),
              quantity: data['quantity'] ?? 1,
              addedAt:
                  data['addedAt'] != null
                      ? (data['addedAt'] as Timestamp).toDate()
                      : DateTime.now(),
            );
          }).toList();

      return Success(cartItems);
    } catch (e) {
      print('❌ Error getting cart: ${e.toString()}');
      return FailureResult(
        failures.UnknownFailure('Failed to get cart: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<CartItemModel>> addToCart(
    String userId,
    String productId,
    int quantity,
  ) async {
    try {
      // First, get the product details
      final productDoc =
          await _firestore.collection('products').doc(productId).get();
      if (!productDoc.exists) {
        return FailureResult(failures.UnknownFailure('Product not found'));
      }

      final productData = productDoc.data()!;
      final product = ProductEntity(
        id: productDoc.id,
        name: productData['name'] ?? '',
        description: productData['description'] ?? '',
        price: (productData['price'] as num?)?.toDouble() ?? 0.0,
        imageUrl: productData['imageURL'] ?? '',
        category: productData['category'] ?? '',
        rating: (productData['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: productData['reviewCount'] ?? 0,
        isAvailable: productData['isAvailable'] ?? true,
        stockQuantity: productData['stockQuantity'] ?? 0,
        tags: List<String>.from(productData['tags'] ?? []),
        createdAt:
            productData['createdAt'] != null
                ? (productData['createdAt'] as Timestamp).toDate()
                : DateTime.now(),
        updatedAt:
            productData['updatedAt'] != null
                ? (productData['updatedAt'] as Timestamp).toDate()
                : DateTime.now(),
      );

      // Check if item already exists in cart
      final existingCartQuery =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cart')
              .where('productId', isEqualTo: productId)
              .get();

      if (existingCartQuery.docs.isNotEmpty) {
        // Update existing item quantity
        final existingDoc = existingCartQuery.docs.first;
        final newQuantity = (existingDoc.data()['quantity'] ?? 0) + quantity;

        await existingDoc.reference.update({
          'quantity': newQuantity,
          'updatedAt': Timestamp.now(),
        });

        // Return updated cart item
        final updatedData = existingDoc.data();
        updatedData['quantity'] = newQuantity;
        updatedData['updatedAt'] = Timestamp.now();

        return Success(
          CartItemModel(
            id: existingDoc.id,
            product: product,
            quantity: newQuantity,
            addedAt: (updatedData['addedAt'] as Timestamp).toDate(),
          ),
        );
      } else {
        // Add new item to cart
        final cartItemData = {
          'productId': productId,
          'productName': product.name,
          'productDescription': product.description,
          'productPrice': product.price,
          'productImageUrl': product.imageUrl,
          'productCategory': product.category,
          'productRating': product.rating,
          'productReviewCount': product.reviewCount,
          'productIsAvailable': product.isAvailable,
          'productStockQuantity': product.stockQuantity,
          'productTags': product.tags,
          'productCreatedAt': Timestamp.fromDate(product.createdAt),
          'productUpdatedAt': Timestamp.fromDate(product.updatedAt),
          'quantity': quantity,
          'addedAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        };

        final docRef = await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .add(cartItemData);

        return Success(
          CartItemModel(
            id: docRef.id,
            product: product,
            quantity: quantity,
            addedAt: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      print('❌ Error adding to cart: ${e.toString()}');
      return FailureResult(
        failures.UnknownFailure('Failed to add to cart: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> removeFromCart(String userId, String cartItemId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .delete();

      return Success(null);
    } catch (e) {
      print('❌ Error removing from cart: ${e.toString()}');
      return FailureResult(
        failures.UnknownFailure('Failed to remove from cart: ${e.toString()}'),
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
      if (quantity <= 0) {
        // If quantity is 0 or negative, remove the item
        await removeFromCart(userId, cartItemId);
        return const Success(null);
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .update({'quantity': quantity, 'updatedAt': Timestamp.now()});

      return const Success(null);
    } catch (e) {
      print('❌ Error updating cart item: ${e.toString()}');
      return FailureResult(
        failures.UnknownFailure('Failed to update cart item: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> clearCart(String userId) async {
    try {
      final cartQuery =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cart')
              .get();

      final batch = _firestore.batch();
      for (final doc in cartQuery.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      return Success(null);
    } catch (e) {
      print('❌ Error clearing cart: ${e.toString()}');
      return FailureResult(
        failures.UnknownFailure('Failed to clear cart: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<double>> getCartTotal(String userId) async {
    try {
      final cartItems = await getCart(userId);
      if (cartItems is Success) {
        final total = cartItems.data!.fold<double>(
          0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
        );
        return Success(total);
      } else {
        return FailureResult(
          failures.UnknownFailure('Failed to get cart total'),
        );
      }
    } catch (e) {
      print('❌ Error getting cart total: ${e.toString()}');
      return FailureResult(
        failures.UnknownFailure('Failed to get cart total: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<int>> getCartItemCount(String userId) async {
    try {
      final cartItems = await getCart(userId);
      if (cartItems is Success) {
        final count = cartItems.data!.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        );
        return Success(count);
      } else {
        return FailureResult(
          failures.UnknownFailure('Failed to get cart item count'),
        );
      }
    } catch (e) {
      print('❌ Error getting cart item count: ${e.toString()}');
      return FailureResult(
        failures.UnknownFailure(
          'Failed to get cart item count: ${e.toString()}',
        ),
      );
    }
  }
}
