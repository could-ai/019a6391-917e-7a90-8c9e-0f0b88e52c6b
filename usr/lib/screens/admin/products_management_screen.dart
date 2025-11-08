import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/auth_service.dart';

class ProductsManagementScreen extends StatefulWidget {
  const ProductsManagementScreen({super.key});

  @override
  State<ProductsManagementScreen> createState() => _ProductsManagementScreenState();
}

class _ProductsManagementScreenState extends State<ProductsManagementScreen> {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'كيك الشوكولاتة الفاخر',
      description: 'كيك شوكولاتة بلجيكية فاخرة مع طبقات من الكريمة',
      price: 150.0,
      wholesalePrice: 120.0,
      category: 'كيك',
      brand: 'كمارا',
      stock: 25,
      imageUrl: '',
      rating: 4.8,
      reviewCount: 156,
    ),
    Product(
      id: '2',
      name: 'بسكويت الزبدة',
      description: 'بسكويت طازج بالزبدة الطبيعية',
      price: 25.0,
      wholesalePrice: 20.0,
      category: 'بسكويت',
      brand: 'المجموعة الاقتصادية',
      stock: 100,
      imageUrl: '',
      rating: 4.5,
      reviewCount: 89,
    ),
    Product(
      id: '3',
      name: 'عصير الفواكه الطبيعي',
      description: 'عصير فواكه طبيعي 100% بدون سكر مضاف',
      price: 15.0,
      wholesalePrice: 12.0,
      category: 'مشروبات',
      brand: 'فلاي جروب',
      stock: 200,
      imageUrl: '',
      rating: 4.7,
      reviewCount: 234,
    ),
  ];

  String _selectedCategory = 'الكل';
  final List<String> _categories = [
    'الكل',
    'كيك',
    'حلويات',
    'بسكويت',
    'مواد غذائية',
    'مشروبات',
  ];

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'الكل') {
      return _products;
    }
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المنتجات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'إجمالي المنتجات',
                    _products.length.toString(),
                    Icons.inventory,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'نفذت الكمية',
                    _products.where((p) => !p.isInStock).length.toString(),
                    Icons.warning,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ),
          // Category Filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Products List
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد منتجات',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(_filteredProducts[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddProductDialog();
        },
        icon: const Icon(Icons.add),
        label: const Text('إضافة منتج'),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.cake,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${product.category} - ${product.brand}'),
            const SizedBox(height: 4),
            Text(
              'السعر: ${product.price.toStringAsFixed(2)} ج.م | الجملة: ${product.wholesalePrice.toStringAsFixed(2)} ج.م',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'المخزون: ${product.stock}',
              style: TextStyle(
                color: product.isInStock ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditProductDialog(product);
                break;
              case 'delete':
                _showDeleteConfirmation(product);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('تعديل'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('حذف', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصفية المنتجات'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('اختر الفئة:'),
            ..._categories.map((category) => RadioListTile<String>(
                  title: Text(category),
                  value: category,
                  groupValue: _selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    final wholesalePriceController = TextEditingController();
    final stockController = TextEditingController();
    final brandController = TextEditingController();
    String selectedCategory = 'كيك';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة منتج جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم المنتج'),
                textDirection: TextDirection.rtl,
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'الوصف'),
                textDirection: TextDirection.rtl,
                maxLines: 3,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'السعر (ج.م)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: wholesalePriceController,
                decoration: const InputDecoration(labelText: 'سعر الجملة (ج.م)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'الكمية'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(labelText: 'العلامة التجارية'),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'الفئة'),
                items: _categories
                    .where((c) => c != 'الكل')
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                setState(() {
                  _products.add(Product(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    description: descController.text,
                    price: double.parse(priceController.text),
                    wholesalePrice: double.parse(wholesalePriceController.text),
                    category: selectedCategory,
                    brand: brandController.text,
                    stock: int.parse(stockController.text),
                    imageUrl: '',
                  ));
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إضافة المنتج بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(Product product) {
    final nameController = TextEditingController(text: product.name);
    final descController = TextEditingController(text: product.description);
    final priceController =
        TextEditingController(text: product.price.toString());
    final wholesalePriceController =
        TextEditingController(text: product.wholesalePrice.toString());
    final stockController =
        TextEditingController(text: product.stock.toString());
    final brandController = TextEditingController(text: product.brand);
    String selectedCategory = product.category;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل المنتج'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم المنتج'),
                textDirection: TextDirection.rtl,
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'الوصف'),
                textDirection: TextDirection.rtl,
                maxLines: 3,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'السعر (ج.م)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: wholesalePriceController,
                decoration: const InputDecoration(labelText: 'سعر الجملة (ج.م)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'الكمية'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(labelText: 'العلامة التجارية'),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'الفئة'),
                items: _categories
                    .where((c) => c != 'الكل')
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = _products.indexWhere((p) => p.id == product.id);
                _products[index] = product.copyWith(
                  name: nameController.text,
                  description: descController.text,
                  price: double.parse(priceController.text),
                  wholesalePrice: double.parse(wholesalePriceController.text),
                  stock: int.parse(stockController.text),
                  brand: brandController.text,
                  category: selectedCategory,
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تعديل المنتج بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل تريد حذف "${product.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _products.removeWhere((p) => p.id == product.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف المنتج'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
