import 'package:json_annotation/json_annotation.dart';

part 'attendance.g.dart'; // Chạy build_runner để tạo file này

@JsonSerializable()
class Attendance {
  final int id; // ID điểm danh
  final int studentId; // Mã học sinh
  final String status; // Trạng thái điểm danh (present, absent, ...)
  final DateTime date; // Ngày điểm danh
  final String? note; // Ghi chú (có thể null)

  Attendance({
    required this.id,
    required this.studentId,
    required this.status,
    required this.date,
    this.note,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceToJson(this);
}
