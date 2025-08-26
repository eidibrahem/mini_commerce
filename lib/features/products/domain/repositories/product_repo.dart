import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';

abstract class ProductRepo {
  Future<Result<List<ProductEntity>>> getProducts();
  Future<Result<List<ProductEntity>>> getProductsByCategory(String category);
  Future<Result<List<ProductEntity>>> searchProducts(String query);
  Future<Result<ProductEntity>> getProductById(String id);
  Future<Result<List<ProductEntity>>> getProductsByPriceRange(
    double minPrice,
    double maxPrice,
  );
  Future<Result<List<String>>> getCategories();
}
