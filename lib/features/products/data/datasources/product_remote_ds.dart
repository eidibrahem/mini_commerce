import '../../../../core/utils/result.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<Result<List<ProductModel>>> getProducts();
  Future<Result<List<ProductModel>>> getProductsByCategory(String category);
  Future<Result<List<ProductModel>>> searchProducts(String query);
  Future<Result<ProductModel>> getProductById(String id);
  Future<Result<List<ProductModel>>> getProductsByPriceRange(
    double minPrice,
    double maxPrice,
  );
  Future<Result<List<String>>> getCategories();
}
