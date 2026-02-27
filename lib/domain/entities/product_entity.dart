import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final String title;
  final String image;
  final String category;
  final double price;
  final double rating;
  final int ratingCount;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.price,
    required this.rating,
    required this.ratingCount,
  });

  @override
  List<Object?> get props => [id, title, image, category, price, rating, ratingCount];

  @override
  String toString() {
    return 'ProductEntity(id: $id, title: $title, category: $category, price: $price)';
  }
}
