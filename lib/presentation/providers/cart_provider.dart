import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';

/// Cart Item Model
class CartItem {
  final ProductModel product;
  final int quantity;
  final String? selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedColor,
  });

  CartItem copyWith({
    ProductModel? product,
    int? quantity,
    String? selectedColor,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  double get totalPrice => product.price * quantity;
}

/// Cart State
class CartState {
  final Map<String, CartItem> items;

  CartState({this.items = const {}});

  int get totalItems => items.values.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice => items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  CartState copyWith({Map<String, CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}

/// Cart Provider - Manages shopping cart state
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

/// Cart State Notifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  /// Add product to cart
  void addToCart(ProductModel product, {String? selectedColor}) {
    final items = Map<String, CartItem>.from(state.items);
    
    if (items.containsKey(product.id)) {
      // Increment quantity if already in cart
      final existingItem = items[product.id]!;
      items[product.id] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      // Add new item
      items[product.id] = CartItem(
        product: product,
        quantity: 1,
        selectedColor: selectedColor,
      );
    }
    
    state = state.copyWith(items: items);
  }

  /// Remove product from cart
  void removeFromCart(String productId) {
    final items = Map<String, CartItem>.from(state.items);
    items.remove(productId);
    state = state.copyWith(items: items);
  }

  /// Update quantity
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final items = Map<String, CartItem>.from(state.items);
    if (items.containsKey(productId)) {
      items[productId] = items[productId]!.copyWith(quantity: quantity);
      state = state.copyWith(items: items);
    }
  }

  /// Clear cart
  void clearCart() {
    state = CartState();
  }

  /// Check if product is in cart
  bool isInCart(String productId) {
    return state.items.containsKey(productId);
  }
}

/// Provider to check if a product is in cart
final isInCartProvider = Provider.family<bool, String>((ref, productId) {
  final cart = ref.watch(cartProvider);
  return cart.items.containsKey(productId);
});