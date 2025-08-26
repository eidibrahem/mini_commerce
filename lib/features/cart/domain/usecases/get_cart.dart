import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repo.dart';

class GetCart implements UseCase<List<CartItemEntity>, NoParams> {
  final CartRepo repository;

  const GetCart(this.repository);

  @override
  Future<Result<List<CartItemEntity>>> call(NoParams params) async {
    return await repository.getCart();
  }
}
