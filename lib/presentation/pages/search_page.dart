// ignore_for_file: deprecated_member_use

import 'package:beauty_bar_demo/data/models/filter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import '../../core/constants/app_colors.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_bottom_sheet.dart';

/// Search Page
/// Main product listing page with search and filter functionality
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Initialize with current filter search query if any
    final currentFilter = ref.read(filterProvider);
    if (currentFilter.searchQuery != null) {
      _searchController.text = currentFilter.searchQuery!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(filteredProductsProvider);
    final filter = ref.watch(filterProvider);
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Search Bar
                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: _searchFocus.hasFocus 
                                  ? AppColors.primary 
                                  : AppColors.border,
                              width: 1.5,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocus,
                            decoration: InputDecoration(
                              hintText: 'Search cosmetics...',
                              hintStyle: const TextStyle(
                                color: AppColors.textLight,
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.textSecondary,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: AppColors.textSecondary,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        ref.read(filterProvider.notifier)
                                            .updateSearchQuery('');
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onChanged: (value) {
                              // Real-time search filtering
                              ref.read(filterProvider.notifier)
                                  .updateSearchQuery(value);
                              setState(() {}); // Update to show/hide clear button
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Filter Button
                      GestureDetector(
                        onTap: _showFilterSheet,
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: filter.hasActiveFilters 
                                ? AppColors.primary 
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: filter.hasActiveFilters 
                                  ? AppColors.primary 
                                  : AppColors.border,
                              width: 1.5,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.tune,
                                color: filter.hasActiveFilters 
                                    ? Colors.white 
                                    : AppColors.textPrimary,
                              ),
                              if (filter.hasActiveFilters)
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Cart Button
                      GestureDetector(
                        onTap: () {
                          // Navigate to cart (not implemented in this demo)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cart feature - Demo only'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: badges.Badge(
                          showBadge: cartState.totalItems > 0,
                          badgeContent: Text(
                            '${cartState.totalItems}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          badgeStyle: const badges.BadgeStyle(
                            badgeColor: AppColors.primary,
                          ),
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.border,
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Active Filters Chips
                  if (filter.hasActiveFilters || filter.searchQuery?.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (filter.searchQuery?.isNotEmpty == true)
                              _buildFilterChip(
                                'Search: "${filter.searchQuery}"',
                                () {
                                  _searchController.clear();
                                  ref.read(filterProvider.notifier)
                                      .updateSearchQuery('');
                                },
                              ),
                            ...filter.selectedBrands.map((brand) => 
                              _buildFilterChip(brand, () {
                                ref.read(filterProvider.notifier).toggleBrand(brand);
                              }),
                            ),
                            ...filter.selectedCategories.map((category) => 
                              _buildFilterChip(category, () {
                                ref.read(filterProvider.notifier).toggleCategory(category);
                              }),
                            ),
                            if (filter.hasActiveFilters)
                              TextButton.icon(
                                onPressed: () {
                                  ref.read(filterProvider.notifier).resetFilters();
                                  _searchController.clear();
                                },
                                icon: const Icon(
                                  Icons.clear_all,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                label: const Text(
                                  'Clear All',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Results Count
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${products.length} Products Found',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    filter.sortBy.displayName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Products Grid
            Expanded(
              child: products.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: products[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Products Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your filters or search',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(filterProvider.notifier).resetFilters();
              _searchController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }
}