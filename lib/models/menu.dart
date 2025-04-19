import 'package:json_annotation/json_annotation.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu {
  final int id;
  final DateTime date;
  final String? breakfast;
  final String? lunch;
  final String? dinner;

  Menu({
    required this.id,
    required this.date,
    this.breakfast,
    this.lunch,
    this.dinner,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
}
