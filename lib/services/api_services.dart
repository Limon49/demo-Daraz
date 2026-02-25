// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const _base = 'https://fakestoreapi.com';

  // Returns JWT token or throws
  static Future<String> login(String username, String password) async {
    final res = await http.post(
      Uri.parse('$_base/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (res.statusCode != 200 && res.statusCode != 201) throw Exception('Login failed: ${res.statusCode}');
    return jsonDecode(res.body)['token'];
  }

  static Future<UserModel> fetchUser(int userId) async {
    final res = await http.get(Uri.parse('$_base/users/$userId'));
    return UserModel.fromJson(jsonDecode(res.body));
  }

  static Future<List<Product>> fetchProducts({String? category}) async {
    final url = category != null
        ? '$_base/products/category/$category'
        : '$_base/products';
    final res = await http.get(Uri.parse(url));
    final list = jsonDecode(res.body) as List;
    return list.map((e) => Product.fromJson(e)).toList();
  }

  static Future<List<String>> fetchCategories() async {
    final res = await http.get(Uri.parse('$_base/products/categories'));
    final list = jsonDecode(res.body) as List;
    return list.map((e) => e.toString()).toList();
  }
}