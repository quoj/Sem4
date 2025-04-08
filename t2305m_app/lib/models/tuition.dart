import 'package:json_annotation/json_annotation.dart';

part 'tuition.g.dart';

@JsonSerializable()
class Tuition {
  final int id;

  @JsonKey(name: 'student_id')
  final int studentId;

  final String description;

  // amount có thể là null, sử dụng double? để tránh lỗi
  final double? amount;

  @JsonKey(name: 'tuition_date')
  final String? tuitionDate;

  Tuition({
    required this.id,
    required this.studentId,
    required this.description,
    this.amount,
    this.tuitionDate,
  });

  factory Tuition.fromJson(Map<String, dynamic> json) =>
      _$TuitionFromJson(json);

  Map<String, dynamic> toJson() => _$TuitionToJson(this);
}

