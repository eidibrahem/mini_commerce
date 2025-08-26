import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repo.dart';

class GetProducts implements UseCase<List<ProductEntity>, NoParams> {
  final ProductRepo repository;

  const GetProducts(this.repository);

  @override
  Future<Result<List<ProductEntity>>> call(NoParams params) async {
    return await repository.getProducts();
  }
}
