class ProductEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  final double rating;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,

    required this.rating,
  });

  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,

    double? rating,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,

      rating: rating ?? this.rating,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProductEntity(id: $id, name: $name, price: $price, rating: $rating)';
  }
}
