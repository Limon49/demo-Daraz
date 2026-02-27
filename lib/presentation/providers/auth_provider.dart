import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  
  UserEntity? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  AuthProvider(this._authRepository);

  // Getters
  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      if (username.isEmpty || password.isEmpty) {
        throw Exception('Username and password are required');
      }

      await _authRepository.login(username, password);
      
      _isLoggedIn = true;
      _user = UserEntity(
        id: 1,
        email: '$username@example.com',
        username: username,
        firstName: 'John',
        lastName: 'Doe',
        phone: '+1234567890',
      );
    } catch (e) {
      _setError('An error occurred: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    _clearError();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

}
