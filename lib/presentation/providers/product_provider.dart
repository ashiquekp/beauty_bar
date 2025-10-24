import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import '../../data/models/filter_model.dart';
import '../../data/repositories/mock_data.dart';

/// Provider for all products
final allProductsProvider = Provider<List<ProductModel>>((ref) {
  return MockDataRepository.getAllProducts();
});

/// Provider for filtered and sorted products
final filteredProductsProvider = Provider<List<ProductModel>>((ref) {
  final allProducts = ref.watch(allProductsProvider);
  final filter = ref.watch(filterProvider);

  // Apply filters
  var filteredProducts = allProducts.where((product) {
    // Search query filter
    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.toLowerCase();
      final matchesName = product.name.toLowerCase().contains(query);
      final matchesBrand = product.brand.toLowerCase().contains(query);
      final matchesCategory = product.category.toLowerCase().contains(query);
      
      if (!matchesName && !matchesBrand && !matchesCategory) {
        return false;
      }
    }

    // Brand filter
    if (filter.selectedBrands.isNotEmpty &&
        !filter.selectedBrands.contains(product.brand)) {
      return false;
    }

    // Category filter
    if (filter.selectedCategories.isNotEmpty &&
        !filter.selectedCategories.contains(product.category)) {
      return false;
    }

    // Price range filter
    if (product.price < filter.minPrice || product.price > filter.maxPrice) {
      return false;
    }

    // Rating filter
    if (filter.minRating != null && product.rating < filter.minRating!) {
      return false;
    }

    // Stock filter
    if (filter.showOnlyInStock && !product.inStock) {
      return false;
    }

    // New products filter
    if (filter.showOnlyNew && !product.isNew) {
      return false;
    }

    // Best sellers filter
    if (filter.showOnlyBestSellers && !product.isBestSeller) {
      return false;
    }

    return true;
  }).toList();

  // Apply sorting
  switch (filter.sortBy) {
    case SortOption.priceLowToHigh:
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
      break;
    case SortOption.priceHighToLow:
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
      break;
    case SortOption.rating:
      filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
      break;
    case SortOption.newest:
      filteredProducts.sort((a, b) => (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0));
      break;
    case SortOption.popular:
      filteredProducts.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      break;
    case SortOption.relevance:
      // Default order
      break;
  }

  return filteredProducts;
});

/// Provider for filter state
final filterProvider = StateNotifierProvider<FilterNotifier, FilterModel>((ref) {
  return FilterNotifier();
});

/// Filter State Notifier
class FilterNotifier extends StateNotifier<FilterModel> {
  FilterNotifier() : super(const FilterModel());

  /// Update search query
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Toggle brand filter
  void toggleBrand(String brand) {
    final brands = List<String>.from(state.selectedBrands);
    if (brands.contains(brand)) {
      brands.remove(brand);
    } else {
      brands.add(brand);
    }
    state = state.copyWith(selectedBrands: brands);
  }

  /// Toggle category filter
  void toggleCategory(String category) {
    final categories = List<String>.from(state.selectedCategories);
    if (categories.contains(category)) {
      categories.remove(category);
    } else {
      categories.add(category);
    }
    state = state.copyWith(selectedCategories: categories);
  }

  /// Update price range
  void updatePriceRange(double min, double max) {
    state = state.copyWith(minPrice: min, maxPrice: max);
  }

  /// Update minimum rating
  void updateMinRating(double? rating) {
    state = state.copyWith(minRating: rating);
  }

  /// Toggle in-stock filter
  void toggleInStock() {
    state = state.copyWith(showOnlyInStock: !state.showOnlyInStock);
  }

  /// Toggle new products filter
  void toggleNew() {
    state = state.copyWith(showOnlyNew: !state.showOnlyNew);
  }

  /// Toggle best sellers filter
  void toggleBestSellers() {
    state = state.copyWith(showOnlyBestSellers: !state.showOnlyBestSellers);
  }

  /// Update sort option
  void updateSortOption(SortOption option) {
    state = state.copyWith(sortBy: option);
  }

  /// Reset all filters
  void resetFilters() {
    state = const FilterModel();
  }

  /// Apply multiple filters at once
  void applyFilters(FilterModel newFilter) {
    state = newFilter;
  }
}

/// Provider for product reviews
final productReviewsProvider = Provider.family<List<ReviewModel>, String>((ref, productId) {
  return MockDataRepository.getProductReviews(productId);
});

/// Provider for available brands
final brandsProvider = Provider<List<String>>((ref) {
  return MockDataRepository.getBrands();
});

/// Provider for available categories
final categoriesProvider = Provider<List<String>>((ref) {
  return MockDataRepository.getCategories();
});