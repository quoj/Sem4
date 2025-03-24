import 'package:json_annotation/json_annotation.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  final int id;
  final String date;
  final String time;
  final String subject;
  final String teacher;

  Schedule({
    required this.id,
    required this.date,
    required this.time,
    required this.subject,
    required this.teacher,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
