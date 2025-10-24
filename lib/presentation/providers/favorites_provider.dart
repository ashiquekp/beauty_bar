import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Favorites Provider - Manages favorite products
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

/// Favorites State Notifier
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  /// Toggle favorite status
  void toggleFavorite(String productId) {
    final favorites = Set<String>.from(state);
    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }
    state = favorites;
  }

  /// Add to favorites
  void addFavorite(String productId) {
    if (!state.contains(productId)) {
      state = {...state, productId};
    }
  }

  /// Remove from favorites
  void removeFavorite(String productId) {
    if (state.contains(productId)) {
      final favorites = Set<String>.from(state);
      favorites.remove(productId);
      state = favorites;
    }
  }

  /// Check if product is favorite
  bool isFavorite(String productId) {
    return state.contains(productId);
  }

  /// Clear all favorites
  void clearFavorites() {
    state = {};
  }
}

/// Provider to check if a product is favorite
final isFavoriteProvider = Provider.family<bool, String>((ref, productId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.contains(productId);
});