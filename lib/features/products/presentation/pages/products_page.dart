import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<ProductProvider>().setSearchQuery('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMedium,
                  ),
                ),
              ),
              onChanged: (value) {
                context.read<ProductProvider>().setSearchQuery(value);
              },
            ),
          ),

          // Category Filter
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                ),
                child: Row(
                  children: [
                    _buildCategoryChip(
                      'All',
                      productProvider.selectedCategory == 'All',
                      () {
                        productProvider.setSelectedCategory('All');
                      },
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    _buildCategoryChip(
                      'Electronics',
                      productProvider.selectedCategory == 'Electronics',
                      () {
                        productProvider.setSelectedCategory('Electronics');
                      },
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    _buildCategoryChip(
                      'Clothing',
                      productProvider.selectedCategory == 'Clothing',
                      () {
                        productProvider.setSelectedCategory('Clothing');
                      },
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    _buildCategoryChip(
                      'Books',
                      productProvider.selectedCategory == 'Books',
                      () {
                        productProvider.setSelectedCategory('Books');
                      },
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    _buildCategoryChip(
                      'Home',
                      productProvider.selectedCategory == 'Home',
                      () {
                        productProvider.setSelectedCategory('Home');
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: AppConstants.paddingMedium),

          // Products Grid
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (productProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppConstants.errorColor,
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        Text(
                          productProvider.errorMessage!,
                          style: TextStyle(color: AppConstants.errorColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        ElevatedButton(
                          onPressed: () {
                            productProvider.loadProducts();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (productProvider.filteredProducts.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: AppConstants.paddingMedium),
                        Text(
                          'No products found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: AppConstants.paddingMedium,
                    mainAxisSpacing: AppConstants.paddingMedium,
                  ),
                  itemCount: productProvider.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = productProvider.filteredProducts[index];
                    return ProductCard(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppConstants.primaryColor.withOpacity(0.2),
      checkmarkColor: AppConstants.primaryColor,
    );
  }
}
