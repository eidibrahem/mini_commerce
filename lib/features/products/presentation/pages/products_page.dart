import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../core/constants.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../app/router.dart';
import '../providers/product_provider.dart';
import '../providers/send_notification_services.dart';
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

            // Quick Action Buttons Row
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Map Button
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouter.map);
                        },
                        icon: const Icon(Icons.map),
                        iconSize: 32,
                        tooltip: AppStrings.getString(context, 'map'),
                        style: IconButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor
                              .withOpacity(0.1),
                          foregroundColor: AppConstants.primaryColor,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.getString(context, 'map'),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  // In-App Review Button
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _showReviewOptions(),
                        icon: const Icon(Icons.star_rate),
                        iconSize: 32,
                        tooltip:
                            AppStrings.getString(context, 'rateApp') ??
                            'Rate App',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.amber[600]?.withOpacity(0.1),
                          foregroundColor: Colors.amber[600],
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.getString(context, 'rateApp') ?? 'Rate App',
                        style: TextStyle(
                          fontSize: 12,

                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  // Notifications Button
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed:
                            () => sendNotification(
                              title: 'Test Notification',
                              body: 'This is a test notification',
                              data: {'route': '/product_details', 'id': '123'},
                            ),
                        icon: const Icon(Icons.notifications),
                        iconSize: 32,
                        tooltip: 'Notifications',
                        style: IconButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            0,
                            34,
                            255,
                          ).withOpacity(0.1),
                          foregroundColor: const Color.fromARGB(
                            255,
                            0,
                            34,
                            255,
                          ),
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
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

  /// Shows a star rating prompt dialog
  Future<void> _showStarPrompt() async {
    double rating = 0;
    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('How was your experience?'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RatingBar.builder(
                        initialRating: rating,
                        minRating: 1,
                        itemCount: 5,
                        itemSize: 32,
                        unratedColor: Colors.grey.shade300,
                        itemBuilder:
                            (c, _) =>
                                const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (r) {
                          setState(() {
                            rating = r;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rating: ${rating.toInt()}/5',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Later'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (rating >= 4) {
                          _requestReview();
                        } else {
                          _openEmailFeedback(); // افتح صفحة ملاحظاتك
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
          ),
    );
  }

  /// Shows a review options dialog
  Future<void> _showReviewOptions() async {
    // Show the star rating prompt directly
    await _showStarPrompt();
  }

  /// Opens email feedback
  Future<void> _openEmailFeedback() async {
    // You can implement email feedback functionality here
    // For now, just show a message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email feedback feature coming soon!'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Requests an in-app review
  Future<void> _requestReview() async {
    try {
      final InAppReview inAppReview = InAppReview.instance;

      // Check if the in-app review is available
      if (await inAppReview.isAvailable()) {
        // Request the in-app review
        await inAppReview.requestReview();
        print('✅ In-app review requested successfully');

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Thank you for your feedback!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        // If in-app review is not available, open the store page
        print('⚠️ In-app review not available, opening store page');
        await inAppReview.openStoreListing(
          appStoreId:
              'your_app_store_id_here', // Replace with your actual App Store ID
        );
      }
    } catch (e) {
      print('❌ Error requesting review: $e');
      // Show a snackbar to inform the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Unable to open review. Please try again later.',
            ),
            backgroundColor: AppConstants.errorColor,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
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
