import '../models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  final bool isWholesale;

  CartItem({
    required this.product,
    required this.quantity,
    required this.isWholesale,
  });

  double get totalPrice {
    final price = isWholesale ? product.wholesalePrice : product.effectivePrice;
    return price * quantity;
  }

  CartItem copyWith({
    Product? product,
    int? quantity,
    bool? isWholesale,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isWholesale: isWholesale ?? this.isWholesale,
    );
  }
}

class CartService {
  static final List<CartItem> _cartItems = [];

  static List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  static int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  static double get totalPrice => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  static void addToCart(Product product, int quantity, bool isWholesale) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id && item.isWholesale == isWholesale,
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItem(
        product: product,
        quantity: quantity,
        isWholesale: isWholesale,
      ));
    }
  }

  static void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
    }
  }

  static void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _cartItems.length) {
      if (newQuantity <= 0) {
        removeFromCart(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
    }
  }

  static void clearCart() {
    _cartItems.clear();
  }

  static bool isInCart(String productId, bool isWholesale) {
    return _cartItems.any(
      (item) => item.product.id == productId && item.isWholesale == isWholesale,
    );
  }
}
