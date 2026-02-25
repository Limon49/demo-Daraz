// lib/models/product.dart
class Product {
  final int id;
  final String title, image, category;
  final double price, rating;
  final int ratingCount;

  const Product({
    required this.id, required this.title, required this.image,
    required this.category, required this.price,
    required this.rating, required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'],
    title: j['title'],
    image: j['image'],
    category: j['category'],
    price: (j['price'] as num).toDouble(),
    rating: (j['rating']['rate'] as num).toDouble(),
    ratingCount: j['rating']['count'],
  );
}

class UserModel {
  final int id;
  final String email, username, firstname, lastname, phone;

  const UserModel({
    required this.id, required this.email, required this.username,
    required this.firstname, required this.lastname, required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id: j['id'],
    email: j['email'],
    username: j['username'],
    firstname: j['name']['firstname'],
    lastname: j['name']['lastname'],
    phone: j['phone'],
  );
}