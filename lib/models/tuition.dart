import 'package:json_annotation/json_annotation.dart';

part 'tuition.g.dart'; // Tạo file .g.dart tự động khi bạn chạy build_runner

@JsonSerializable()
class Tuition {
  final int id; // Thuộc tính id
  final int studentId; // Thuộc tính student_id
  final String description; // Thuộc tính description
  final double? amount; // Thuộc tính amount, có thể null
  final DateTime? tuitionDate; // Thuộc tính tuition_date, có thể null

  Tuition({
    required this.id,
    required this.studentId,
    required this.description,
    this.amount,
    this.tuitionDate,
  });

  // Tạo factory từ JSON
  factory Tuition.fromJson(Map<String, dynamic> json) => _$TuitionFromJson(json);

  // Tạo Map JSON từ đối tượng Tuition
  Map<String, dynamic> toJson() => _$TuitionToJson(this);
}
