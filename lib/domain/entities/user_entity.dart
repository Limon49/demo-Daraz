import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, email, username, firstName, lastName, phone];

  @override
  String toString() {
    return 'UserEntity(id: $id, username: $username, email: $email)';
  }
}
