import '../constants/api_constants.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/datasources/remote/auth_remote_data_source.dart';
import '../../data/datasources/remote/product_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';

class DependencyInjection {
  static late final AuthRepository authRepository;
  static late final ProductRepository productRepository;

  static void initialize() {
    final authRemoteDataSource = AuthRemoteDataSourceImpl(
      baseUrl: ApiConstants.baseUrl,
    );
    final productRemoteDataSource = ProductRemoteDataSourceImpl(
      baseUrl: ApiConstants.baseUrl,
    );

    authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
    );
    productRepository = ProductRepositoryImpl(
      remoteDataSource: productRemoteDataSource,
    );
  }
}
