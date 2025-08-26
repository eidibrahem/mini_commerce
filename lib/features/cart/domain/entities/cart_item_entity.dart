import '../../../products/domain/entities/product_entity.dart';

class CartItemEntity {
  final String id;
  final ProductEntity product;
  final int quantity;
  final DateTime addedAt;

  const CartItemEntity({
    required this.id,
    required this.product,
    required this.quantity,
    required this.addedAt,
  });

  double get totalPrice => product.price * quantity;

  CartItemEntity copyWith({
    String? id,
    ProductEntity? product,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CartItemEntity(id: $id, product: ${product.name}, quantity: $quantity, totalPrice: $totalPrice)';
  }
}
