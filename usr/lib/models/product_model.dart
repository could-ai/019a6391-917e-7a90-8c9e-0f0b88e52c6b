class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double wholesalePrice;
  final String category;
  final String brand;
  final int stock;
  final String imageUrl;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final bool isOnSale;
  final double? salePrice;
  final DateTime? saleEndDate;
  final int minWholesaleQuantity;
  final String unit; // 'piece', 'box', 'carton'

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.wholesalePrice,
    required this.category,
    required this.brand,
    required this.stock,
    required this.imageUrl,
    List<String>? images,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFeatured = false,
    this.isOnSale = false,
    this.salePrice,
    this.saleEndDate,
    this.minWholesaleQuantity = 10,
    this.unit = 'piece',
  }) : images = images ?? [imageUrl];

  double get effectivePrice => isOnSale && salePrice != null ? salePrice! : price;

  bool get isInStock => stock > 0;

  bool get isLowStock => stock > 0 && stock <= 10;

  String getCategoryNameAr() {
    return category;
  }

  String getUnitNameAr() {
    switch (unit) {
      case 'piece':
        return 'قطعة';
      case 'box':
        return 'علبة';
      case 'carton':
        return 'كرتونة';
      default:
        return 'قطعة';
    }
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? wholesalePrice,
    String? category,
    String? brand,
    int? stock,
    String? imageUrl,
    List<String>? images,
    double? rating,
    int? reviewCount,
    bool? isFeatured,
    bool? isOnSale,
    double? salePrice,
    DateTime? saleEndDate,
    int? minWholesaleQuantity,
    String? unit,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFeatured: isFeatured ?? this.isFeatured,
      isOnSale: isOnSale ?? this.isOnSale,
      salePrice: salePrice ?? this.salePrice,
      saleEndDate: saleEndDate ?? this.saleEndDate,
      minWholesaleQuantity: minWholesaleQuantity ?? this.minWholesaleQuantity,
      unit: unit ?? this.unit,
    );
  }
}

class ProductReview {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final List<String> images;
  final DateTime createdAt;
  final bool isVerifiedPurchase;

  ProductReview({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    this.images = const [],
    required this.createdAt,
    this.isVerifiedPurchase = false,
  });
}
