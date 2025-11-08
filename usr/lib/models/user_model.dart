enum UserRole {
  admin,      // المدير العام
  editor,     // المحرر
  supervisor, // المشرف
  customer,   // العميل
}

class User {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? phone;
  final String? address;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final String? profileImage;
  final Map<String, bool> permissions;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.phone,
    this.address,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    this.profileImage,
    Map<String, bool>? permissions,
  }) : permissions = permissions ?? _getDefaultPermissions(role);

  static Map<String, bool> _getDefaultPermissions(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return {
          'manage_users': true,
          'manage_products': true,
          'manage_orders': true,
          'view_reports': true,
          'manage_settings': true,
          'manage_coupons': true,
        };
      case UserRole.editor:
        return {
          'manage_users': false,
          'manage_products': true,
          'manage_orders': false,
          'view_reports': false,
          'manage_settings': false,
          'manage_coupons': false,
        };
      case UserRole.supervisor:
        return {
          'manage_users': false,
          'manage_products': false,
          'manage_orders': true,
          'view_reports': true,
          'manage_settings': false,
          'manage_coupons': false,
        };
      case UserRole.customer:
        return {
          'manage_users': false,
          'manage_products': false,
          'manage_orders': false,
          'view_reports': false,
          'manage_settings': false,
          'manage_coupons': false,
        };
    }
  }

  String getRoleNameAr() {
    switch (role) {
      case UserRole.admin:
        return 'مدير عام';
      case UserRole.editor:
        return 'محرر';
      case UserRole.supervisor:
        return 'مشرف';
      case UserRole.customer:
        return 'عميل';
    }
  }

  bool hasPermission(String permission) {
    return permissions[permission] ?? false;
  }

  User copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? phone,
    String? address,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    String? profileImage,
    Map<String, bool>? permissions,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      profileImage: profileImage ?? this.profileImage,
      permissions: permissions ?? this.permissions,
    );
  }
}
