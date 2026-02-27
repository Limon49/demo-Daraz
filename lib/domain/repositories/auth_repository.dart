import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> login(String username, String password);
  Future<UserEntity> getCurrentUser();
  Future<void> logout();
}
