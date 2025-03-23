import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String name;
  final String email;

  User({required this.name, required this.email}); // Dùng 'required' để tránh null

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '', // Thêm fallback để tránh null
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}
