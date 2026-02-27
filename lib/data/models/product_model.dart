import '../../domain/entities/product_entity.dart';

class ProductModel {
  final int id;
  final String title;
  final String image;
  final String category;
  final double price;
  final double rating;
  final int ratingCount;

  const ProductModel({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.price,
    required this.rating,
    required this.ratingCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating']['rate'] as num).toDouble(),
      ratingCount: json['rating']['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'category': category,
      'price': price,
      'rating': {
        'rate': rating,
        'count': ratingCount,
      },
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      image: image,
      category: category,
      price: price,
      rating: rating,
      ratingCount: ratingCount,
    );
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      title: entity.title,
      image: entity.image,
      category: entity.category,
      price: entity.price,
      rating: entity.rating,
      ratingCount: entity.ratingCount,
    );
  }
}
