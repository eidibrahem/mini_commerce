import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../app/router.dart';
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
    return Directionality(
      textDirection: AppStrings.getTextDirection(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.getString(context, 'products')),
          actions: [
            // Language Switcher
            Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.language),
                  tooltip: AppStrings.getString(context, 'changeLanguage'),
                  onSelected: (String languageCode) {
                    languageProvider.changeLanguage(languageCode);
                  },
                  itemBuilder:
                      (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'en',
                          child: Row(
                            children: [
                              Text(AppStrings.getString(context, 'english')),
                              const SizedBox(width: 8),
                              if (languageProvider.isEnglish())
                                const Icon(Icons.check, color: Colors.green),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'ar',
                          child: Row(
                            children: [
                              Text(AppStrings.getString(context, 'arabic')),
                              const SizedBox(width: 8),
                              if (languageProvider.isArabic())
                                const Icon(Icons.check, color: Colors.green),
                            ],
                          ),
                        ),
                      ],
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              tooltip: AppStrings.getString(context, 'cart'),
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.cart);
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: AppStrings.getString(context, 'profile'),
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.profile);
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
                  hintText: AppStrings.getString(context, 'searchProducts'),
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

            // Map Button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.map);
                  },
                  icon: const Icon(Icons.map),
                  label: Text(AppStrings.getString(context, 'map')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingMedium,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMedium,
                      ),
                    ),
                  ),
                ),
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
                        AppStrings.getString(context, 'all'),
                        productProvider.selectedCategory == 'All',
                        () {
                          productProvider.setSelectedCategory('All');
                        },
                      ),
                      const SizedBox(width: AppConstants.paddingSmall),
                      _buildCategoryChip(
                        AppStrings.getString(context, 'electronics'),
                        productProvider.selectedCategory == 'Electronics',
                        () {
                          productProvider.setSelectedCategory('Electronics');
                        },
                      ),
                      const SizedBox(width: AppConstants.paddingSmall),
                      _buildCategoryChip(
                        AppStrings.getString(context, 'clothing'),
                        productProvider.selectedCategory == 'Clothing',
                        () {
                          productProvider.setSelectedCategory('Clothing');
                        },
                      ),
                      const SizedBox(width: AppConstants.paddingSmall),
                      _buildCategoryChip(
                        AppStrings.getString(context, 'books'),
                        productProvider.selectedCategory == 'Books',
                        () {
                          productProvider.setSelectedCategory('Books');
                        },
                      ),
                      const SizedBox(width: AppConstants.paddingSmall),
                      _buildCategoryChip(
                        AppStrings.getString(context, 'home'),
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
                            child: Text(AppStrings.getString(context, 'retry')),
                          ),
                        ],
                      ),
                    );
                  }

                  if (productProvider.filteredProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          Text(
                            AppStrings.getString(context, 'noProductsFound'),
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
