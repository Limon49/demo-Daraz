import 'package:flutter/foundation.dart';
import '../domain/entities/user_entity.dart';
import '../domain/entities/product_entity.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/product_provider.dart';

class AppProvider extends ChangeNotifier {
  late final AuthProvider _authProvider;
  late final ProductProvider _productProvider;

  AppProvider({
    required AuthProvider authProvider,
    required ProductProvider productProvider,
  }) {
    _authProvider = authProvider;
    _productProvider = productProvider;
    
    // Listen to changes from child providers and notify listeners
    _authProvider.addListener(_onChildProviderChanged);
    _productProvider.addListener(_onChildProviderChanged);
  }

  void _onChildProviderChanged() {
    notifyListeners();
  }

  // Auth delegation
  UserEntity? get user => _authProvider.user;
  bool get isLoading => _authProvider.isLoading;
  String? get errorMessage => _authProvider.errorMessage;
  bool get isLoggedIn => _authProvider.isLoggedIn;

  Future<void> login(String username, String password) async {
    await _authProvider.login(username, password);
  }

  void logout() {
    _authProvider.logout();
  }

  // Product delegation
  List<ProductEntity> productsFor(String category) {
    return _productProvider.getProductsForCategory(category);
  }

  bool isLoadingProducts(String category) {
    return _productProvider.isLoadingProducts(category);
  }

  // Convenience method to match screen usage
  bool isLoadingProductsFor(String category) {
    return isLoadingProducts(category);
  }

  String? errorFor(String category) {
    return _productProvider.getErrorForCategory(category);
  }

  List<String> get categories => _productProvider.categories;
  bool get isLoadingCategories => _productProvider.isLoadingCategories;
  String? get categoriesError => _productProvider.categoriesError;

  Future<void> loadProducts(String category) async {
    await _productProvider.loadProducts(category);
  }

  Future<void> loadCategories() async {
    await _productProvider.loadCategories();
  }

  Future<void> refreshProducts(String category) async {
    await _productProvider.refreshProducts(category);
  }

  // Convenience method for refresh
  Future<void> refresh(String category) async {
    await refreshProducts(category);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onChildProviderChanged);
    _productProvider.removeListener(_onChildProviderChanged);
    super.dispose();
  }
}
