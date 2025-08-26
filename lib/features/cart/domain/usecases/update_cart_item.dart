import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/cart_repo.dart';

class UpdateCartItemParams {
  final String cartItemId;
  final int quantity;

  const UpdateCartItemParams({
    required this.cartItemId,
    required this.quantity,
  });
}

class UpdateCartItem implements UseCase<void, UpdateCartItemParams> {
  final CartRepo repository;

  const UpdateCartItem(this.repository);

  @override
  Future<Result<void>> call(UpdateCartItemParams params) async {
    return await repository.updateCartItem(params.cartItemId, params.quantity);
  }
}
