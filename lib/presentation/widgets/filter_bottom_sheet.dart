import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/filter_model.dart';
import '../providers/product_provider.dart';

/// Filter Bottom Sheet
/// Displays filter options for products
class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late FilterModel _tempFilter;

  @override
  void initState() {
    super.initState();
    _tempFilter = ref.read(filterProvider);
  }

  @override
  Widget build(BuildContext context) {
    final brands = ref.watch(brandsProvider);
    final categories = ref.watch(categoriesProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.divider, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _tempFilter = const FilterModel();
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(filterProvider.notifier).applyFilters(_tempFilter);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  _buildSectionTitle('Price Range'),
                  RangeSlider(
                    values: RangeValues(_tempFilter.minPrice, _tempFilter.maxPrice),
                    min: 0,
                    max: 10000,
                    divisions: 100,
                    activeColor: AppColors.primary,
                    labels: RangeLabels(
                      '¥${_tempFilter.minPrice.toInt()}',
                      '¥${_tempFilter.maxPrice.toInt()}',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _tempFilter = _tempFilter.copyWith(
                          minPrice: values.start,
                          maxPrice: values.end,
                        );
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '¥${_tempFilter.minPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '¥${_tempFilter.maxPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Brands
                  _buildSectionTitle('Brands'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: brands.map((brand) {
                      final isSelected = _tempFilter.selectedBrands.contains(brand);
                      return _buildFilterChip(
                        label: brand,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            final brands = List<String>.from(_tempFilter.selectedBrands);
                            if (isSelected) {
                              brands.remove(brand);
                            } else {
                              brands.add(brand);
                            }
                            _tempFilter = _tempFilter.copyWith(selectedBrands: brands);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  
                  // Categories
                  _buildSectionTitle('Categories'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((category) {
                      final isSelected = _tempFilter.selectedCategories.contains(category);
                      return _buildFilterChip(
                        label: category,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            final cats = List<String>.from(_tempFilter.selectedCategories);
                            if (isSelected) {
                              cats.remove(category);
                            } else {
                              cats.add(category);
                            }
                            _tempFilter = _tempFilter.copyWith(selectedCategories: cats);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  
                  // Rating
                  _buildSectionTitle('Minimum Rating'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _tempFilter.minRating ?? 0,
                          min: 0,
                          max: 5,
                          divisions: 10,
                          activeColor: AppColors.primary,
                          label: _tempFilter.minRating?.toStringAsFixed(1) ?? '0.0',
                          onChanged: (value) {
                            setState(() {
                              _tempFilter = _tempFilter.copyWith(
                                minRating: value > 0 ? value : null,
                              );
                            });
                          },
                        ),
                      ),
                      Text(
                        _tempFilter.minRating?.toStringAsFixed(1) ?? 'Any',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Quick Filters
                  _buildSectionTitle('Quick Filters'),
                  const SizedBox(height: 12),
                  _buildCheckboxTile(
                    'In Stock Only',
                    _tempFilter.showOnlyInStock,
                    (value) {
                      setState(() {
                        _tempFilter = _tempFilter.copyWith(showOnlyInStock: value);
                      });
                    },
                  ),
                  _buildCheckboxTile(
                    'New Products',
                    _tempFilter.showOnlyNew,
                    (value) {
                      setState(() {
                        _tempFilter = _tempFilter.copyWith(showOnlyNew: value);
                      });
                    },
                  ),
                  _buildCheckboxTile(
                    'Best Sellers',
                    _tempFilter.showOnlyBestSellers,
                    (value) {
                      setState(() {
                        _tempFilter = _tempFilter.copyWith(showOnlyBestSellers: value);
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Sort By
                  _buildSectionTitle('Sort By'),
                  const SizedBox(height: 8),
                  ...SortOption.values.map((option) {
                    return RadioListTile<SortOption>(
                      title: Text(
                        option.displayName,
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: option,
                      groupValue: _tempFilter.sortBy,
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _tempFilter = _tempFilter.copyWith(sortBy: value);
                          });
                        }
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxTile(String title, bool value, ValueChanged<bool> onChanged) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      value: value,
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (val) => onChanged(val ?? false),
    );
  }
}