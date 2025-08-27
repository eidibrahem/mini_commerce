import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repo.dart';

class AddToCartParams {
  final String userId;
  final String productId;
  final int quantity;

  const AddToCartParams({
    required this.userId,
    required this.productId,
    required this.quantity,
  });
}

class AddToCart implements UseCase<CartItemEntity, AddToCartParams> {
  final CartRepo repository;

  const AddToCart(this.repository);

  @override
  Future<Result<CartItemEntity>> call(AddToCartParams params) async {
    return await repository.addToCart(
      params.userId,
      params.productId,
      params.quantity,
    );
  }
}
