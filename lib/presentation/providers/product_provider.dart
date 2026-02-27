import 'package:flutter/foundation.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _productRepository;
  
  final Map<String, List<ProductEntity>> _productsByCategory = {};
  final Map<String, bool> _loadingByCategory = {};
  final Map<String, String?> _errorsByCategory = {};
  
  List<String> _categories = [];
  bool _isLoadingCategories = false;
  String? _categoriesError;

  ProductProvider(
    this._productRepository,
  );

  // Getters
  List<ProductEntity> getProductsForCategory(String category) {
    return _productsByCategory[category] ?? [];
  }

  bool isLoadingProducts(String category) {
    return _loadingByCategory[category] ?? false;
  }

  String? getErrorForCategory(String category) {
    return _errorsByCategory[category];
  }

  List<String> get categories => _categories;
  bool get isLoadingCategories => _isLoadingCategories;
  String? get categoriesError => _categoriesError;

  Future<void> loadProducts(String category) async {
    if (_loadingByCategory[category] == true) return;

    print(' category: $category');
    _setLoadingForCategory(category, true);
    _clearErrorForCategory(category);

    try {
      final products = await _productRepository.getProducts(category: category == 'all' ? null : category);
      _productsByCategory[category] = products;
      print('loaded ${products.length} products for category: $category');
    } catch (e) {
      _setErrorForCategory(category, 'An error occurred: ${e.toString()}');
    } finally {
      _setLoadingForCategory(category, false);
    }
  }

  Future<void> loadCategories() async {
    if (_isLoadingCategories) return;

    _setLoadingCategories(true);
    _clearCategoriesError();

    try {
      final categories = await _productRepository.getCategories();
      _categories = ['all', ...categories];
    } catch (e) {
      _setCategoriesError('An error occurred: ${e.toString()}');
    } finally {
      _setLoadingCategories(false);
    }
  }

  Future<void> refreshProducts(String category) async {
    _productsByCategory.remove(category);
    await loadProducts(category);
  }

  void _setLoadingForCategory(String category, bool loading) {
    _loadingByCategory[category] = loading;
    notifyListeners();
  }

  void _setErrorForCategory(String category, String error) {
    _errorsByCategory[category] = error;
    notifyListeners();
  }

  void _clearErrorForCategory(String category) {
    _errorsByCategory[category] = null;
    notifyListeners();
  }

  void _setLoadingCategories(bool loading) {
    _isLoadingCategories = loading;
    notifyListeners();
  }

  void _setCategoriesError(String error) {
    _categoriesError = error;
    notifyListeners();
  }

  void _clearCategoriesError() {
    _categoriesError = null;
    notifyListeners();
  }

}
