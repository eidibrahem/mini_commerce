import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repo.dart';

class GetCartParams {
  final String userId;
  const GetCartParams({required this.userId});
}

class GetCart implements UseCase<List<CartItemEntity>, GetCartParams> {
  final CartRepo repository;

  const GetCart(this.repository);

  @override
  Future<Result<List<CartItemEntity>>> call(GetCartParams params) async {
    return await repository.getCart(params.userId);
  }
}
