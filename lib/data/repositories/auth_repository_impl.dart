import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<void> login(String username, String password) async {
    await remoteDataSource.login(username, password);
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final userData = await remoteDataSource.getUser(1);
    final userModel = UserModel.fromJson(userData);
    return userModel.toEntity();
  }

  @override
  Future<void> logout() async {
  }
}
