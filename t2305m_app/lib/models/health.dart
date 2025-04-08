import 'package:json_annotation/json_annotation.dart';

part 'health.g.dart'; // Đảm bảo tên file `.g.dart` khớp với tên file gốc

@JsonSerializable()
class Health {
  final int id;
  final String name;
  @JsonKey(name: 'birthDate')
  final String birthDate;
  final String gender;
  final double height;
  final double weight;
  @JsonKey(name: 'healthNotes')
  final String healthNotes;

  Health({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.height,
    required this.weight,
    required this.healthNotes,
  });

  // Tạo factory method từ JSON
  factory Health.fromJson(Map<String, dynamic> json) => _$HealthFromJson(json);

  // Chuyển đổi đối tượng sang JSON
  Map<String, dynamic> toJson() => _$HealthToJson(this);
}
