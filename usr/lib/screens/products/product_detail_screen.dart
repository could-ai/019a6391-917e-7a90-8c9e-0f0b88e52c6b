import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isFavorite = false;
  bool _isWholesale = false;

  @override
  Widget build(BuildContext context) {
    final effectivePrice = _isWholesale
        ? widget.product.wholesalePrice
        : widget.product.effectivePrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المنتج'),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorite
                        ? 'تمت الإضافة إلى المفضلة'
                        : 'تمت الإزالة من المفضلة',
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images
            SizedBox(
              height: 300,
              child: Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: Icon(
                    Icons.cake,
                    size: 120,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Brand and Category
                  Row(
                    children: [
                      Chip(
                        label: Text(widget.product.brand),
                        backgroundColor: Colors.blue.shade100,
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(widget.product.category),
                        backgroundColor: Colors.green.shade100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.product.rating}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' (${widget.product.reviewCount} تقييم)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sale Type Selector
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'نوع البيع:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                label: const Text('تجزئة'),
                                selected: !_isWholesale,
                                onSelected: (selected) {
                                  setState(() {
                                    _isWholesale = false;
                                    _quantity = 1;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ChoiceChip(
                                label: const Text('جملة'),
                                selected: _isWholesale,
                                onSelected: (selected) {
                                  setState(() {
                                    _isWholesale = true;
                                    _quantity =
                                        widget.product.minWholesaleQuantity;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        if (_isWholesale)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'الحد الأدنى: ${widget.product.minWholesaleQuantity} ${widget.product.getUnitNameAr()}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Price
                  Row(
                    children: [
                      Text(
                        '${effectivePrice.toStringAsFixed(2)} ريال',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_isWholesale)
                        Text(
                          'للـ ${widget.product.getUnitNameAr()}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                  if (_isWholesale && widget.product.price > widget.product.wholesalePrice)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'وفر ${(widget.product.price - widget.product.wholesalePrice).toStringAsFixed(2)} ريال لكل وحدة!',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Stock Status
                  Row(
                    children: [
                      Icon(
                        widget.product.isInStock
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: widget.product.isInStock
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.product.isInStock
                            ? 'متوفر في المخزون (${widget.product.stock})'
                            : 'غير متوفر',
                        style: TextStyle(
                          color: widget.product.isInStock
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  // Description
                  const Text(
                    'الوصف',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'الكمية:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              setState(() {
                                if (_isWholesale) {
                                  if (_quantity >
                                      widget.product.minWholesaleQuantity) {
                                    _quantity--;
                                  }
                                } else {
                                  if (_quantity > 1) _quantity--;
                                }
                              });
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() {
                                if (_quantity < widget.product.stock) {
                                  _quantity++;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Total Price
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'المجموع:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${(effectivePrice * _quantity).toStringAsFixed(2)} ريال',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: widget.product.isInStock
              ? () {
                  CartService.addToCart(
                    widget.product,
                    _quantity,
                    _isWholesale,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تمت الإضافة إلى السلة'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            'إضافة إلى السلة',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
