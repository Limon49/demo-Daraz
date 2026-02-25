// lib/state/app_provider.dart
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_services.dart';

class AppProvider extends ChangeNotifier {
  // --- Auth state ---
  String? _token;
  UserModel? _user;
  bool get isLoggedIn => _token != null;
  UserModel? get user => _user;

  Future<void> login(String username, String password) async {
    try {
      print('Starting login for: $username');
      _token = await ApiService.login(username, password);
      print('Login successful, token: $_token');
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
    // FakeStore tokens don't encode userId; use userId=1 for demo
    _user = await ApiService.fetchUser(1);
    notifyListeners();
  }

  void logout() {
    _token = null;
    _user = null;
    notifyListeners();
  }

  // --- Products per tab ---
  // Map of category -> products
  final Map<String, List<Product>> _products = {};
  final Map<String, bool> _loading = {};
  final Map<String, String?> _errors = {};

  List<Product> productsFor(String category) => _products[category] ?? [];
  bool isLoading(String category) => _loading[category] ?? false;
  String? errorFor(String category) => _errors[category];

  Future<void> loadProducts(String category) async {
    if (_loading[category] == true) return;
    _loading[category] = true;
    _errors[category] = null;
    notifyListeners();
    try {
      final cat = category == 'all' ? null : category;
      _products[category] = await ApiService.fetchProducts(category: cat);
    } catch (e) {
      _errors[category] = e.toString();
    }
    _loading[category] = false;
    notifyListeners();
  }

  Future<void> refresh(String category) async {
    _products.remove(category);
    await loadProducts(category);
  }
}