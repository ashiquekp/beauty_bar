/// Filter Model - Represents search and filter criteria
class FilterModel {
  final String? searchQuery;
  final List<String> selectedBrands;
  final List<String> selectedCategories;
  final double minPrice;
  final double maxPrice;
  final double? minRating;
  final bool showOnlyInStock;
  final bool showOnlyNew;
  final bool showOnlyBestSellers;
  final SortOption sortBy;

  const FilterModel({
    this.searchQuery,
    this.selectedBrands = const [],
    this.selectedCategories = const [],
    this.minPrice = 0,
    this.maxPrice = 10000,
    this.minRating,
    this.showOnlyInStock = false,
    this.showOnlyNew = false,
    this.showOnlyBestSellers = false,
    this.sortBy = SortOption.relevance,
  });

  /// Create a copy with modifications
  FilterModel copyWith({
    String? searchQuery,
    List<String>? selectedBrands,
    List<String>? selectedCategories,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? showOnlyInStock,
    bool? showOnlyNew,
    bool? showOnlyBestSellers,
    SortOption? sortBy,
  }) {
    return FilterModel(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBrands: selectedBrands ?? this.selectedBrands,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      showOnlyInStock: showOnlyInStock ?? this.showOnlyInStock,
      showOnlyNew: showOnlyNew ?? this.showOnlyNew,
      showOnlyBestSellers: showOnlyBestSellers ?? this.showOnlyBestSellers,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  /// Check if any filters are applied
  bool get hasActiveFilters {
    return selectedBrands.isNotEmpty ||
        selectedCategories.isNotEmpty ||
        minPrice > 0 ||
        maxPrice < 10000 ||
        minRating != null ||
        showOnlyInStock ||
        showOnlyNew ||
        showOnlyBestSellers;
  }

  /// Reset all filters
  FilterModel reset() {
    return const FilterModel();
  }
}

/// Sort options for product listing
enum SortOption {
  relevance,
  priceLowToHigh,
  priceHighToLow,
  rating,
  newest,
  popular,
}

extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.relevance:
        return 'Relevance';
      case SortOption.priceLowToHigh:
        return 'Price: Low to High';
      case SortOption.priceHighToLow:
        return 'Price: High to Low';
      case SortOption.rating:
        return 'Highest Rating';
      case SortOption.newest:
        return 'Newest';
      case SortOption.popular:
        return 'Most Popular';
    }
  }
}