import '../../domain/entities/user_entity.dart';

class UserModel {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['name']['firstname'] as String,
      lastName: json['name']['lastname'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': {
        'firstname': firstName,
        'lastname': lastName,
      },
      'phone': phone,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      username: entity.username,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phone: entity.phone,
    );
  }
}
