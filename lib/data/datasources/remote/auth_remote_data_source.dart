import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<String> login(String username, String password);
  Future<Map<String, dynamic>> getUser(int userId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final String baseUrl;

  AuthRemoteDataSourceImpl({required this.baseUrl});

  @override
  Future<String> login(String username, String password) async {
    try {
      final response = await _makeHttpRequest(
        method: 'POST',
        endpoint: '/auth/login',
        body: {'username': username, 'password': password},
      );

      if (response['token'] == null) {
        throw Exception('Login failed: No token received');
      }

      return response['token'] as String;
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getUser(int userId) async {
    try {
      final response = await _makeHttpRequest(
        method: 'GET',
        endpoint: '/users/$userId',
      );

      return response;
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch user: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> _makeHttpRequest({
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
