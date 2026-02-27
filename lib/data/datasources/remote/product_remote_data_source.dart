import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ProductRemoteDataSource {
  Future<List<Map<String, dynamic>>> getProducts({String? category});
  Future<List<String>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final String baseUrl;

  ProductRemoteDataSourceImpl({required this.baseUrl});

  @override
  Future<List<Map<String, dynamic>>> getProducts({String? category}) async {
    try {
      final endpoint = category != null ? '/products/category/$category' : '/products';
      final response = await _makeHttpRequest(
        method: 'GET',
        endpoint: endpoint,
      );

      if (response is! List) {
        throw Exception('Invalid response format: Expected list');
      }

      return List<Map<String, dynamic>>.from(response);
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch products: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await _makeHttpRequest(
        method: 'GET',
        endpoint: '/products/categories',
      );

      if (response is! List) {
        throw Exception('Invalid response format: Expected list');
      }

      return response.map((e) => e.toString()).toList();
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch categories: ${e.toString()}');
    }
  }

  Future<dynamic> _makeHttpRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final defaultHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };

    late http.Response response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(uri, headers: defaultHeaders);
        break;
      case 'POST':
        response = await http.post(
          uri,
          headers: defaultHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'PUT':
        response = await http.put(
          uri,
          headers: defaultHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
        break;
      case 'DELETE':
        response = await http.delete(uri, headers: defaultHeaders);
        break;
      default:
        throw Exception('Unsupported HTTP method: $method');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw Exception('Client error: ${response.statusCode}');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
