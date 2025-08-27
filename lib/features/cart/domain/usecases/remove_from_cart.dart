import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/cart_repo.dart';

class RemoveFromCartParams {
  final String userId;
  final String cartItemId;

  const RemoveFromCartParams({required this.userId, required this.cartItemId});
}

class RemoveFromCart implements UseCase<void, RemoveFromCartParams> {
  final CartRepo repository;

  const RemoveFromCart(this.repository);

  @override
  Future<Result<void>> call(RemoveFromCartParams params) async {
    return await repository.removeFromCart(params.userId, params.cartItemId);
  }
}
