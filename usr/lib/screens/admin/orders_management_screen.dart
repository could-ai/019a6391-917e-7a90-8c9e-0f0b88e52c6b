import 'package:flutter/material.dart';
import '../../models/order_model.dart';

class OrdersManagementScreen extends StatefulWidget {
  const OrdersManagementScreen({super.key});

  @override
  State<OrdersManagementScreen> createState() => _OrdersManagementScreenState();
}

class _OrdersManagementScreenState extends State<OrdersManagementScreen> {
  final List<Order> _orders = [
    Order(
      id: 'ORD001',
      customerName: 'أحمد محمد',
      customerPhone: '0501234567',
      customerAddress: 'الرياض، حي النرجس',
      items: [
        OrderItem(
          productName: 'كيك الشوكولاتة الفاخر',
          quantity: 2,
          price: 150.0,
          isWholesale: false,
        ),
        OrderItem(
          productName: 'بسكويت الزبدة',
          quantity: 5,
          price: 25.0,
          isWholesale: false,
        ),
      ],
      totalAmount: 425.0,
      status: OrderStatus.pending,
      orderDate: DateTime.now().subtract(const Duration(hours: 2)),
      paymentMethod: 'الدفع عند الاستلام',
    ),
    Order(
      id: 'ORD002',
      customerName: 'فاطمة علي',
      customerPhone: '0507654321',
      customerAddress: 'جدة، حي الفيصلية',
      items: [
        OrderItem(
          productName: 'عصير الفواكه الطبيعي',
          quantity: 20,
          price: 12.0,
          isWholesale: true,
        ),
      ],
      totalAmount: 240.0,
      status: OrderStatus.processing,
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      paymentMethod: 'الدفع عند الاستلام',
    ),
    Order(
      id: 'ORD003',
      customerName: 'محمد سعيد',
      customerPhone: '0509876543',
      customerAddress: 'الدمام، حي الشاطئ',
      items: [
        OrderItem(
          productName: 'كيك الشوكولاتة الفاخر',
          quantity: 1,
          price: 150.0,
          isWholesale: false,
        ),
      ],
      totalAmount: 150.0,
      status: OrderStatus.shipped,
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      paymentMethod: 'الدفع عند الاستلام',
    ),
  ];

  OrderStatus? _selectedStatusFilter;

  List<Order> get _filteredOrders {
    if (_selectedStatusFilter == null) {
      return _orders;
    }
    return _orders.where((o) => o.status == _selectedStatusFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الطلبات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
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
                    'إجمالي الطلبات',
                    _orders.length.toString(),
                    Icons.shopping_bag,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'قيد المعالجة',
                    _orders
                        .where((o) =>
                            o.status == OrderStatus.pending ||
                            o.status == OrderStatus.processing)
                        .length
                        .toString(),
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'مكتملة',
                    _orders
                        .where((o) => o.status == OrderStatus.delivered)
                        .length
                        .toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ),
          // Status Filter Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('الكل', null),
                _buildFilterChip('قيد الانتظار', OrderStatus.pending),
                _buildFilterChip('قيد المعالجة', OrderStatus.processing),
                _buildFilterChip('قيد الشحن', OrderStatus.shipped),
                _buildFilterChip('تم التوصيل', OrderStatus.delivered),
                _buildFilterChip('ملغي', OrderStatus.cancelled),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Orders List
          Expanded(
            child: _filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_outlined,
                            size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد طلبات',
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
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      return _buildOrderCard(_filteredOrders[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, OrderStatus? status) {
    final isSelected = _selectedStatusFilter == status;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedStatusFilter = selected ? status : null;
          });
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: order.getStatusColor(),
          child: Text(
            order.id.substring(3),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          order.customerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('رقم الطلب: ${order.id}'),
            Text(
              '${order.totalAmount.toStringAsFixed(2)} ج.م',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: order.getStatusColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                order.getStatusText(),
                style: TextStyle(
                  color: order.getStatusColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Info
                _buildInfoRow(Icons.person, 'العميل', order.customerName),
                _buildInfoRow(Icons.phone, 'الهاتف', order.customerPhone),
                _buildInfoRow(
                    Icons.location_on, 'العنوان', order.customerAddress),
                _buildInfoRow(Icons.payment, 'طريقة الدفع', order.paymentMethod),
                _buildInfoRow(
                  Icons.calendar_today,
                  'تاريخ الطلب',
                  '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year} ${order.orderDate.hour}:${order.orderDate.minute.toString().padLeft(2, '0')}',
                ),
                const Divider(),
                const Text(
                  'المنتجات:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.productName} ${item.isWholesale ? "(جملة)" : ""}',
                            ),
                          ),
                          Text(
                            '${item.quantity} × ${item.price.toStringAsFixed(2)} = ${item.totalPrice.toStringAsFixed(2)} ج.م',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'الإجمالي:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${order.totalAmount.toStringAsFixed(2)} ج.م',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Action Buttons
                if (order.status != OrderStatus.delivered &&
                    order.status != OrderStatus.cancelled)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _updateOrderStatus(order),
                          icon: const Icon(Icons.update, size: 18),
                          label: const Text('تحديث الحالة'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _cancelOrder(order),
                          icon: const Icon(Icons.cancel, size: 18),
                          label: const Text('إلغاء'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصفية الطلبات'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<OrderStatus?>(
              title: const Text('الكل'),
              value: null,
              groupValue: _selectedStatusFilter,
              onChanged: (value) {
                setState(() {
                  _selectedStatusFilter = value;
                });
                Navigator.pop(context);
              },
            ),
            ...OrderStatus.values.map((status) => RadioListTile<OrderStatus?>(
                  title: Text(Order.getStatusTextStatic(status)),
                  value: status,
                  groupValue: _selectedStatusFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatusFilter = value;
                    });
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _updateOrderStatus(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحديث حالة الطلب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: OrderStatus.values
              .where((s) => s != OrderStatus.cancelled)
              .map((status) => RadioListTile<OrderStatus>(
                    title: Text(Order.getStatusTextStatic(status)),
                    value: status,
                    groupValue: order.status,
                    onChanged: (value) {
                      setState(() {
                        final index = _orders.indexWhere((o) => o.id == order.id);
                        _orders[index] = order.copyWith(status: value!);
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم تحديث حالة الطلب'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _cancelOrder(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الطلب'),
        content: const Text('هل تريد إلغاء هذا الطلب؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لا'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = _orders.indexWhere((o) => o.id == order.id);
                _orders[index] =
                    order.copyWith(status: OrderStatus.cancelled);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إلغاء الطلب'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('نعم، إلغاء'),
          ),
        ],
      ),
    );
  }
}
