import '../../../../core/utils/result.dart';
import '../../../../core/error/failures.dart' as failures;
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repo.dart';
import '../datasources/product_remote_ds.dart';
import '../models/product_model.dart';

class ProductRepoImpl implements ProductRepo {
  final ProductRemoteDataSource remoteDataSource;

  const ProductRepoImpl({required this.remoteDataSource});

  @override
  Future<Result<List<ProductEntity>>> getProducts() async {
    try {
      final result = await remoteDataSource.getProducts();
      return result.map(
        (productModels) =>
            productModels.map((model) => model as ProductEntity).toList(),
      );
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to get products'));
    }
  }

  @override
  Future<Result<List<ProductEntity>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final result = await remoteDataSource.getProductsByCategory(category);
      return result.map(
        (productModels) =>
            productModels.map((model) => model as ProductEntity).toList(),
      );
    } catch (e) {
      return FailureResult(
        failures.UnknownFailure('Failed to get products by category'),
      );
    }
  }

  @override
  Future<Result<List<ProductEntity>>> searchProducts(String query) async {
    try {
      final result = await remoteDataSource.searchProducts(query);
      return result.map(
        (productModels) =>
            productModels.map((model) => model as ProductEntity).toList(),
      );
    } catch (e) {
      return FailureResult(
        failures.UnknownFailure('Failed to search products'),
      );
    }
  }

  @override
  Future<Result<ProductEntity>> getProductById(String id) async {
    try {
      final result = await remoteDataSource.getProductById(id);
      return result.map((productModel) => productModel as ProductEntity);
    } catch (e) {
      return FailureResult(
        failures.UnknownFailure('Failed to get product by id'),
      );
    }
  }

  @override
  Future<Result<List<ProductEntity>>> getProductsByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    try {
      final result = await remoteDataSource.getProductsByPriceRange(
        minPrice,
        maxPrice,
      );
      return result.map(
        (productModels) =>
            productModels.map((model) => model as ProductEntity).toList(),
      );
    } catch (e) {
      return FailureResult(
        failures.UnknownFailure('Failed to get products by price range'),
      );
    }
  }

  @override
  Future<Result<List<String>>> getCategories() async {
    try {
      return await remoteDataSource.getCategories();
    } catch (e) {
      return FailureResult(failures.UnknownFailure('Failed to get categories'));
    }
  }
}
