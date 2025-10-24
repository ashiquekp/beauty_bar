/// Product Model - Represents a cosmetic product
/// Immutable data class following MVVM pattern
class ProductModel {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double? originalPrice; // For showing discounts
  final String mainImage;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final String category;
  final List<String> colors; // Available color variants
  final String description;
  final List<String> features;
  final Map<String, String> specifications;
  final bool isNew;
  final bool isBestSeller;
  final int stock;

  const ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.originalPrice,
    required this.mainImage,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.colors,
    required this.description,
    required this.features,
    required this.specifications,
    this.isNew = false,
    this.isBestSeller = false,
    required this.stock,
  });

  /// Calculate discount percentage
  double? get discountPercentage {
    if (originalPrice == null || originalPrice! <= price) return null;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  /// Check if product is in stock
  bool get inStock => stock > 0;

  /// Check if product has discount
  bool get hasDiscount => discountPercentage != null;

  /// Create copy with modifications
  ProductModel copyWith({
    String? id,
    String? name,
    String? brand,
    double? price,
    double? originalPrice,
    String? mainImage,
    List<String>? images,
    double? rating,
    int? reviewCount,
    String? category,
    List<String>? colors,
    String? description,
    List<String>? features,
    Map<String, String>? specifications,
    bool? isNew,
    bool? isBestSeller,
    int? stock,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      mainImage: mainImage ?? this.mainImage,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      category: category ?? this.category,
      colors: colors ?? this.colors,
      description: description ?? this.description,
      features: features ?? this.features,
      specifications: specifications ?? this.specifications,
      isNew: isNew ?? this.isNew,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      stock: stock ?? this.stock,
    );
  }
}

/// Review Model - Represents a customer review
class ReviewModel {
  final String id;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final DateTime date;
  final List<String> images;
  final bool isVerifiedPurchase;

  const ReviewModel({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
    this.images = const [],
    this.isVerifiedPurchase = false,
  });
}