import '../../../../core/utils/result.dart';
import '../../../../core/error/failures.dart' as failures;
import '../models/product_model.dart';
import 'product_remote_ds.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<Result<List<ProductModel>>> getProducts() async {
    try {
      // Get products from Firebase Firestore
      final querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      print(querySnapshot.docs.length);
      print(querySnapshot.docs.first.data());
      print(querySnapshot.docs[1].data());
      print(querySnapshot.docs[2].data());
      // Convert Firestore documents to ProductModel objects
      final productsList =
          querySnapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data()))
              .toList();

      // Debug print
      print('📦 Products loaded from Firestore:');
      for (var doc in querySnapshot.docs) {
        print(doc.data());
        print('📦 Product ID: ${doc.id}');
      }

      return Success(productsList);
    } catch (e) {
      print('❌ Error getting products: ${e.toString()}');
      return FailureResult(
        failures.UnknownFailure('Failed to get products: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<ProductModel>>> getProductsByCategory(
    String category,
  ) async {
    try {
      // Get products by category from Firebase Firestore
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .where('category', isEqualTo: category)
              .get();

      // Convert Firestore documents to ProductModel objects
      final productsList =
          querySnapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data()))
              .toList();

      // Debug print
      print('📦 Products for category [$category]:');
      for (var doc in querySnapshot.docs) {
        print(doc.data());
        print('📦 Product ID: ${doc.id}');
      }

      return Success(productsList);
    } catch (e) {
      print('❌ Error getting products by category: ${e.toString()}');
      return FailureResult(
        failures.UnknownFailure(
          'Failed to get products by category: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<List<ProductModel>>> searchProducts(String query) async {
    try {
      // Get products from Firebase Firestore and filter by search query
      final querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      // Convert Firestore documents to ProductModel objects and filter
      final productsList =
          querySnapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data()))
              .where(
                (product) =>
                    product.name.toLowerCase().contains(query.toLowerCase()) ||
                    product.description.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();

      // Debug print
      print('🔍 Search results for query [$query]:');
      print('📦 Found ${productsList.length} products');

      return Success(productsList);
    } catch (e) {
      print('❌ Error searching products: ${e.toString()}');
      return FailureResult(
        failures.UnknownFailure('Failed to search products: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<ProductModel>> getProductById(String id) async {
    try {
      // Get product by ID from Firebase Firestore
      final docSnapshot =
          await FirebaseFirestore.instance.collection('products').doc(id).get();

      if (!docSnapshot.exists) {
        return FailureResult(failures.NotFoundFailure('Product not found'));
      }

      // Convert Firestore document to ProductModel object
      final productData = docSnapshot.data()!;
      final product = ProductModel.fromJson(productData);

      // Debug print
      print('📦 Product by ID [$id]:');
      print(productData);

      return Success(product);
    } catch (e) {
      print('❌ Error getting product by ID: ${e.toString()}');
      return FailureResult(
        failures.UnknownFailure('Failed to get product by ID: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<ProductModel>>> getProductsByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    try {
      // Get products by price range from Firebase Firestore
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .where('price', isGreaterThanOrEqualTo: minPrice)
              .where('price', isLessThanOrEqualTo: maxPrice)
              .get();

      // Convert Firestore documents to ProductModel objects
      final productsList =
          querySnapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data()))
              .toList();

      // Debug print
      print('💰 Products in price range [\$$minPrice - \$$maxPrice]:');
      print('📦 Found ${productsList.length} products');

      return Success(productsList);
    } catch (e) {
      print('❌ Error getting products by price range: ${e.toString()}');
      return FailureResult(
        failures.UnknownFailure(
          'Failed to get products by price range: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<List<String>>> getCategories() async {
    await Future.delayed(const Duration(seconds: 1));
    return const Success([
      'Electronics',
      'Clothing',
      'Books',
      'Home',
      'Sports',
    ]);
  }
}
