import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/remote/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<ProductEntity>> getProducts({String? category}) async {
    final productsData = await remoteDataSource.getProducts(category: category);
    final productModels = productsData.map((data) => ProductModel.fromJson(data)).toList();
    final productEntities = productModels.map((model) => model.toEntity()).toList();
    return productEntities;
  }

  @override
  Future<List<String>> getCategories() async {
    final categories = await remoteDataSource.getCategories();
    return categories;
  }
}
