import '../models/user_model.dart';

class AuthService {
  static User? _currentUser;

  // Demo users - In production, this would connect to Supabase
  static final List<Map<String, dynamic>> _demoUsers = [
    {
      'id': '1',
      'name': 'ahmed ali',
      'username': 'ahmed ali',
      'password': 'ahmed2013699',
      'email': 'ahmed@happysweet.com',
      'role': UserRole.admin,
    },
    {
      'id': '2',
      'name': 'محرر المتجر',
      'username': 'editor',
      'password': 'editor123',
      'email': 'editor@happysweet.com',
      'role': UserRole.editor,
    },
    {
      'id': '3',
      'name': 'مشرف الطلبات',
      'username': 'supervisor',
      'password': 'super123',
      'email': 'supervisor@happysweet.com',
      'role': UserRole.supervisor,
    },
    {
      'id': '4',
      'name': 'عميل تجريبي',
      'username': 'customer',
      'password': 'customer123',
      'email': 'customer@happysweet.com',
      'phone': '0501234567',
      'address': 'الرياض، المملكة العربية السعودية',
      'role': UserRole.customer,
    },
  ];

  static User? login(String username, String password) {
    try {
      final userData = _demoUsers.firstWhere(
        (user) =>
            user['username'] == username && user['password'] == password,
      );

      _currentUser = User(
        id: userData['id'],
        name: userData['name'],
        username: userData['username'],
        email: userData['email'],
        phone: userData['phone'],
        address: userData['address'],
        role: userData['role'],
        createdAt: DateTime.now(),
      );

      return _currentUser;
    } catch (e) {
      return null;
    }
  }

  static void logout() {
    _currentUser = null;
  }

  static User? getCurrentUser() {
    return _currentUser;
  }

  static bool isLoggedIn() {
    return _currentUser != null;
  }

  static bool isAdmin() {
    return _currentUser?.role == UserRole.admin;
  }

  static bool isEditor() {
    return _currentUser?.role == UserRole.editor;
  }

  static bool isSupervisor() {
    return _currentUser?.role == UserRole.supervisor;
  }

  static bool isCustomer() {
    return _currentUser?.role == UserRole.customer;
  }

  static bool hasPermission(String permission) {
    return _currentUser?.hasPermission(permission) ?? false;
  }
}
