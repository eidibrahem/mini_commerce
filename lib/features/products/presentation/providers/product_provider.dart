import 'package:flutter/foundation.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products.dart';

class ProductProvider extends ChangeNotifier {
  final GetProducts getProducts;

  ProductProvider(this.getProducts);

  List<ProductEntity> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<ProductEntity> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<ProductEntity> get filteredProducts {
    List<ProductEntity> filtered = _products;

    if (_selectedCategory != 'All') {
      filtered =
          filtered
              .where((product) => 'product.category' == _selectedCategory)
              .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (product) =>
                    product.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    product.description.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    return filtered;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setProducts(List<ProductEntity> products) {
    _products = products;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await getProducts(NoParams());

      result.when(
        success: (products) {
          _setProducts(products);
          _setError(null);
        },
        failure: (failure) {
          _setError('Failed to load products');
          _setProducts([]);
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred');
      _setProducts([]);
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _setError(null);
  }

  void clearFilters() {
    _selectedCategory = 'All';
    _searchQuery = '';
    notifyListeners();
  }
}
