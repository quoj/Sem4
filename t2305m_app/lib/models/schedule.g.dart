// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      id: (json['id'] as num).toInt(),
      classId: (json['classId'] as num).toInt(),
      subjectId: json['subjectId'] as String,
      teacherId: (json['teacherId'] as num).toInt(),
      dayOfWeek: DateTime.parse(json['dayOfWeek'] as String),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'id': instance.id,
      'classId': instance.classId,
      'subjectId': instance.subjectId,
      'teacherId': instance.teacherId,
      'dayOfWeek': instance.dayOfWeek.toIso8601String(),
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
    };
