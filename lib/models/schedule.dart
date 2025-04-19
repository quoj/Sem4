import 'package:json_annotation/json_annotation.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  final int id;
  final int classId;
  final String subjectId; // Tên môn học
  final int teacherId; // ID giáo viên
  final DateTime dayOfWeek; // Chuyển từ int thành DateTime
  final DateTime startTime;
  final DateTime endTime;

  Schedule({
    required this.id,
    required this.classId,
    required this.subjectId,
    required this.teacherId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      classId: json['classId'],
      subjectId: json['subjectId'],
      teacherId: json['teacherId'],
      dayOfWeek: DateTime.parse(json['startTime'].substring(0, 10)), // Lấy ngày từ startTime
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "classId": classId,
    "subjectId": subjectId,
    "teacherId": teacherId,
    "dayOfWeek": dayOfWeek.toIso8601String().split('T').first, // Chỉ lấy ngày
    "startTime": startTime.toIso8601String(),
    "endTime": endTime.toIso8601String(),
  };
}
